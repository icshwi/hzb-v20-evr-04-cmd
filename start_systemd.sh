#!/bin/bash
export IOC_NAME=hzb-v20-evr-04
export IOC_EXEC_DIR=/epics/iocs/cmds/$IOC_NAME-cmd
export VAR_DIR="/epics/iocs/var"
export BASE_VER="7.0.1.1"
export REQUIRE_VER="3.0.4"
export E3_BIN_DIR="/epics/base-$BASE_VER/require/$REQUIRE_VER/bin"
export PROCSERV="/usr/bin/procServ"
export PROCSERV_PORT=2002
export PROCSERV_RUN_DIR=$IOC_NAME
export PROCSERV_LOG_FILE=out-HZB-V20-EVR-04

export IOC_ST_CMD=st.$IOC_NAME.cmd
source "$E3_BIN_DIR/setE3Env.bash"

# Ensure log and run directories exist
mkdir -p $VAR_DIR/log/procServ
mkdir -p $VAR_DIR/run/procServ/$PROCSERV_RUN_DIR

# Remove backgrounding '&' for startup with systemd
$PROCSERV -f -L $VAR_DIR/log/procServ/$PROCSERV_LOG_FILE -i ^C^D -c $VAR_DIR/run/procServ/$PROCSERV_RUN_DIR $PROCSERV_PORT $E3_BIN_DIR/iocsh.bash $IOC_EXEC_DIR/$IOC_ST_CMD
