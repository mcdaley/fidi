#!/bin/sh

#
# Script:  test_loggin.sh
#
# Purpose: Test the logging functionality in rdf_utils.sh
#

program=`basename ${0}`

#
# The path could also be include in ~/.bashrc and could
# use an environment variable instead of hard-coding the path
#
. /Users/mike/projects/bash/fidi/fidi_utils.sh

#
# Turn on logging
#
log=/tmp/fidi.log
setup_logging  -m 4 -l ${log}
roll_log_files ${log}
#
# Log a few messages
#
log "Logging to ${log}"
log "Log message one"
log "Log message two"
msg "This should not be in the log file"

msg "## Cat the log file <${log}> ##"
cat ${log}
msg "## EOF ##"

#
# Run a few commands
#
run "echo My first command"
run "echo My second command"

#
# Log the output of ls
#
log "DEBUG: the output from ls /tmp/"
run "ls /tmp/"

unset FIDI_LOG_FILE
run "echo This message should NOT be logged"

msg "## Cat the log file <${log}> ##"
cat ${log}
msg "## EOF ##"

exit 0
