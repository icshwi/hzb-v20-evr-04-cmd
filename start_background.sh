#!/bin/bash
export IOC_EXEC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
export VAR_DIR="/epics/iocs/var"
export BASE_VER="7.0.1.1"
export REQUIRE_VER="3.0.4"
export E3_BIN_DIR="/epics/base-$BASE_VER/require/$REQUIRE_VER/bin"
export PROCSERV="/bin/procServ"
export PROCSERV_PORT=2002
export PROCSERV_RUN_DIR=hzb-v20-evr-04
export PROCSERV_LOG_FILE=out-HZB-V20-EVR-04
mkdir -p $VAR_DIR/run/procServ/$PROCSERV_RUN_DIR
export IOC_ST_CMD=st.hzb-v20-evr-04.cmd
source "$E3_BIN_DIR/setE3Env.bash"
$PROCSERV -f -L $VAR_DIR/log/procServ/$PROCSERV_LOG_FILE -i ^C^D -c $VAR_DIR/run/procServ/$PROCSERV_RUN_DIR $PROCSERV_PORT $E3_BIN_DIR/iocsh.bash $IOC_EXEC_DIR/$IOC_ST_CMD &
