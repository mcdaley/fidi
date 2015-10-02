#!/bin/sh

################################################################################
#
# SCRIPT:   <Name of the shell script>
#
# PURPOSE:  Defines a template for writing shell scripts
#
# TODO:     Search for the TODO statements throughout the template and update
#           the code for your specific shell script.
#
################################################################################

#
# Define global variables
#
program=`basename ${0}`
verbose="1"

################################################################################
# FUNCTION: usage()
################################################################################
usage()
{
    ############################################################################
    # TODO: DEFINE THE SCRIPT'S USAGE
    ############################################################################
    echo "\n"
    echo "Usage: ${program} [-e <example>] [-h]"
    echo "       -e: Example parameter"
    echo "       -h: Help"
    echo ""
}

################################################################################
# FUNCTION: process_cmd_line_args()
################################################################################
process_cmd_line_args()
{
    ############################################################################
    # TODO: DEFINE THE SCRIPT'S COMMAND LINE ARGUMENTS
    ############################################################################
    while getopts e:h option
    do
      case "$option"
      in
        h) usage
           exit 0
           ;;
        e) example=${OPTARG}	## Define example command line arg.
           ;;
       \?) usage
           exit 1
           ;;
      esac
    done

    ############################################################################
    # TODO: HANDLE MANDATORY OPTIONS BY SETTING DEFAULT VALUES OR EXITING
    #
    # if [ ! $MANDATORY ]
    #   msg   "ERROR: MANDATORY is required"
    #   usage
    #   exit  -1
    # fi
    #
    # OR
    # 
    # if [ ! $MANDATORY ]
    #   MANDATORY="DEFAULT_VALUE"
    # fi
    ############################################################################
    
    return 0
}

################################################################################
# FUNCTION: source_fidi_env()
################################################################################
source_fidi_env()
{
    ############################################################################
    # TODO: DEFINE THE CORRECT CareerQB ENVIRONMENT PROFILE
    ############################################################################
    if [ "${FIDI_HOME}"]
    then
      shell_utils=${FIDI_HOME}/fidi_utils.sh
    else
      shell_utils=${HOME}/scripts/fidi/fidi_utils.sh
    fi

    if [ ! -f "${shell_utils}" ]
    then
      echo "ERROR: Unable to find FIDI utility functions: ${shell_utils}"
      echo "ERROR: Exiting ${program}..."
      exit -1
    else
      . ${shell_utils}
    fi

    return 0
}

################################################################################
# main()
################################################################################


source_fidi_env

process_cmd_line_args $*

print_header ${program} $*

############################################################################
# TODO: WRITE THE SCRIPT
############################################################################

exit 0
