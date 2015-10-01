################################################################################
#
# FILE:    def.fidi.sh
#
# PURPOSE: Defines fidi environmental variables for the specific RAILS_ENV
#
################################################################################

#
# Define global RDF environment variables
#
ACUSYS_DIR="/acufs001";		            export ACUSYS_DIR
ACUSYS_LOGS="${ACUSYS_DIR}/log";		   export ACUSYS_LOGS
TEMP1FS_DIR="/temp1fs";                export TEMP1FS_DIR

PATH=${PATH}:${ACUSYS_DIR}/script;		export PATH

#
# Define the host specific environment variables
#

HOST_NAME=`/usr/bin/uname -n`

case ${HOST_NAME} in
#Production Environment
    u060rtk1) RDF_ENV="p"
              EAST_DOMAINS="011 014 016 017 017c 018 021 023 024 029 034 035";   export EAST_DOMAINS
              EFR1P014_DIR="efr1p014"; 	export EFR1P014_DIR
              EFR1P016_DIR="efr1p016";		export EFR1P016_DIR
              EFR1P024_DIR="efr1p024";		export EFR1P024_DIR
              EFR1P011_DIR="efr1p011";    export EFR1P011_DIR
              EFR1P017_DIR="efr1p017";    export EFR1P017_DIR
              EFR1P017c_DIR="efr1p017c";  export EFR1P017c_DIR
              EFR1P018_DIR="efr1p018";    export EFR1P018_DIR
              EFR1P021_DIR="efr1p021";    export EFR1P021_DIR
              EFR1P023_DIR="efr1p023";    export EFR1P023_DIR
              EFR1P029_DIR="efr1p029";    export EFR1P029_DIR
              EFR1P034_DIR="efr1p034";    export EFR1P034_DIR
              EFR1P035_DIR="efr1p035";    export EFR1P035_DIR
              
              
              
              ;;
#Testing Environment
    u060rtk3) RDF_ENV="m"
              EAST_DOMAINS="011 014 016 017 017c 018 021 023 024 029 034 035";            export EAST_DOMAINS
              EFR1P014_DIR="efr1p014"; 	export EFR1P014_DIR
              EFR1P016_DIR="efr1p016";		export EFR1P016_DIR
              EFR1P024_DIR="efr1p024";		export EFR1P024_DIR
              EFR1P011_DIR="efr1p011";    export EFR1P011_DIR
              EFR1P017_DIR="efr1p017";    export EFR1P017_DIR
              EFR1P017c_DIR="efr1p017c";  export EFR1P017c_DIR
              EFR1P018_DIR="efr1p018";    export EFR1P018_DIR
              EFR1P021_DIR="efr1p021";    export EFR1P021_DIR
              EFR1P023_DIR="efr1p023";    export EFR1P023_DIR
              EFR1P029_DIR="efr1p029";    export EFR1P029_DIR
              EFR1P034_DIR="efr1p034";    export EFR1P034_DIR
              EFR1P035_DIR="efr1p035";    export EFR1P035_DIR
              ;;
esac

#
# Source the RDF Shell utilities
#

##shell_utils=${ACUSYS_DIR}/script/rdf_utils.sh
shell_utils=/home/qbmgr/script/careerqb_utils.sh

if [ ! -f "${shell_utils}" ]
then
    echo "ERROR: Unable to find CareerQB utility functions: ${shell_utils}"
    echo "ERROR: Exiting ${program}..."
    exit -1
else
    . ${shell_utils}
fi

