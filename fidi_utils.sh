################################################################################
#
# PROGRAM: fidi_utils.sh
#
# PURPOSE: Defines common SHELL utilities that make it easy to write
#          shell scripts to manage your applications and environments.
#
################################################################################


#################################################################################
# Function: print_header()
#################################################################################
print_header()
{
  my_program=${1}

  echo ""
  echo "########################################################################"
  echo "#"
  echo "#     Running: $my_program"
  echo "#     Date:    `date`"
  echo "#     Command: $*"
  echo "#"
  echo "########################################################################"
  echo ""

  return 0
}

#################################################################################
# Function: print_banner()
#################################################################################
print_banner()
{
  my_program=${1}

  today=`date`
  msg="\n                                                                      \
       ####################################################################\n  \
       #     Running: $my_program                                          \n  \
       #     Date:    $today                                               \n  \
       #     Command: $*                                                   \n  \
       ####################################################################\n\n"
  
  echo ${msg}

  if [ "${FIDI_LOG_FILE}" -a ! "${NO_RUN}" ]
  then
    echo ${msg} >> ${FIDI_LOG_FILE}
  fi

  return 0
}

###################################################################################
# Function: dbg()
###################################################################################

export IS_VERBOSE="1"

dbg()
{
  if [ -n "${verbose}" -a "${verbose}" -ge "${IS_VERBOSE}"  ]
  then
      eval echo `date "+ [%m/%d/%y %H:%M:%S]"` \"$*\"
  fi
}

###################################################################################
# Function: msg()
###################################################################################
msg()
{
  ##eval echo ${program} `date "+ [%m/%d/%y %H:%M:%S]"` \"$*\"
  eval echo `date "+ [%m/%d/%y %H:%M:%S]"` \"$*\"
}

###################################################################################
# Function: setup_logging()
###################################################################################
setup_logging()
{
  while getopts m:l:h option
  do
  	case "$option"
  	in
	    h) echo "Usage: setup_logginig -l <log file> [-m <max files>] [-h]"
	       return 0;
	       ;;
      l) FIDI_LOG_FILE=${OPTARG};      export FIDI_LOG_FILE
         ;;
      m) FIDI_MAX_LOG_FILES=${OPTARG}; export FIDI_MAX_LOG_FILES
         ;;
     \?) echo "Unknown argument [${option}]"
         ;;
  	esac
  done

  if [ ! "${FIDI_LOG_FILE}" ]
  then
  	echo "\nERROR: Failed to specify a log file"
  	echo "Usage: setup_logginig -l <log file> [-m <max files>] [-h]"
  	echo "Exiting..."
  	return -1
  fi

  return 0
}

###################################################################################
# Function: log()
###################################################################################
log()
{
  eval echo `date "+ [%m/%d/%y %H:%M:%S]"` \"$*\"

  if [ "${FIDI_LOG_FILE}" -a ! "${NO_RUN}" ]
  then
      eval echo `date "+ [%m/%d/%y %H:%M:%S]"` \"$*\"  >> ${FIDI_LOG_FILE}
  fi
}

###################################################################################
# Function: run()
###################################################################################
run()
{
  ###############################################################################
  # TODO: Should work w/ just using the log instead of msg, so I could remove
  #       the outer if-else logic testing for FIDI_LOG_FILE.
  ###############################################################################

  #
  # Log and run a UNIX command. If logging is configured log the output to
  # the FIDI_LOG_FILE else write the output to SDOUT.
  #
  if [ ! "${FIDI_LOG_FILE}" ]
  then
    if [ ! "${NO_RUN}" ]
    then
      msg  $*
      eval $*
    else
      msg "CMD: $*"
    fi
  else
    if [ ! "${NO_RUN}" ]
    then
      log  $*
      eval $* | tee -a ${FIDI_LOG_FILE}
    else
      log "CMD: $*"
    fi
  fi

  return $?
}

#################################################################################
# Function: check_error()
#
# Purpose:  Checks the return code from a command and prints an error message
#           and exits the program if the error code is NOT equal to 0. The
#           function saves writing the if [ $? -ne 0 ] then .. fi
#           logic everytime you want to check the status of a command.
#
# Args:     The function expects at least 2 arguments. The first is the return
#           code and the 2nd thru n are the string to print out if the 
#           return code does not equal 0.
#################################################################################
check_error()
{
  if [ $# -lt 2 ]
  then
    log "Must pass at least 2 arguments to the check_error function"
    log "Exiting ${program}..."
    exit -2
  fi

  #
  # Print an error and exit the progam if the previous
  # command failed.
  #

  status=${1}
  shift

  if [ status -ne 0 ]
  then
    log "ERROR: $*"
    log "Exiting ${progam}..."
    exit -2
  fi

  return 0
}

################################################################################
# FUNCTION: roll_log_files()
################################################################################
roll_log_files()
{
  if [ $# -ne 1 ]
  then
    msg "ERROR: Failed to pass log filename to roll_log_files()"
    return -1
  fi

  log_file=${1}

  #
  # If the log file does not exist then the log files do not have to
  # be rolled.
  #
  if [ ! -f "${log_file}" ]
  then
    msg "Log file ${log_file} does not exist - nothing to do"
    return 0
  fi

  #
  # Roll the log files
  #
  if [ ! "${FIDI_MAX_LOG_FILES}" ]
  then
    MAX="5"
  else
    MAX="${FIDI_MAX_LOG_FILES}"
  fi

  last=${MAX}
  prev=`expr ${MAX} - 1`

  while [ "${last}" -gt 0 ]
  do
    ##msg "DBG: Last=[${last}]  Prev=[${prev}]"
    if [ "${prev}" -ge 1 ]
    then
      if [ -f "${log_file}.${prev}" ]
      then
        cmd="mv ${log_file}.${prev} ${log_file}.${last}"
        run "${cmd}"
      fi
    else
      #
      # Already know log file exist, just roll the last log file.
      #
      cmd="mv ${log_file}  ${log_file}.${last}"
      run "${cmd}"
    fi

    last=`expr "${last}" - 1`
    prev=`expr "${prev}" - 1`
  done

  msg "Completed rolling log file ${log_file}"

  return 0
}
