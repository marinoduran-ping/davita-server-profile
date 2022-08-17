#!/usr/bin/env bash

DIRNAME=`dirname "$0"`/..
DIRNAME=`(cd "$DIRNAME" && pwd)`
# Set DIRNAME_ESC - this is DIRNAME but with spaces that are replaced with %20
DIRNAME_ESC=${DIRNAME// /%20}
DEFAULT_DIR="$DIRNAME/server/default"

PF_ROOT=$(cd "$(dirname "$0")/.."; pwd)

# Read an optional running configuration file
if [ "x$RUN_CONF" = "x" ]; then
    RUN_CONF="$DIRNAME/bin/run.conf"
fi
if [ -r "$RUN_CONF" ]; then
    . "$RUN_CONF"
fi

# Check for run.properties
runprops="$DIRNAME/bin/run.properties"
if [ ! -f "$runprops" ]; then
    warn "Missing run.properties; using defaults."
    runprops=""
fi

CLASSPATH="$DIRNAME/bin/pf-consoleutils.jar"
CLASSPATH="$CLASSPATH:$DEFAULT_DIR/lib/*"
CLASSPATH="$CLASSPATH:$PF_ROOT/lib/*"
CLASSPATH="$CLASSPATH:$DEFAULT_DIR/deploy/*"
CLASSPATH="$CLASSPATH:$DEFAULT_DIR/conf/"

# Setup the JVM
if [ "x$JAVA" = "x" ]; then
    if [ "x$JAVA_HOME" != "x" ]; then
            JAVA="$JAVA_HOME/bin/java"
    else
            JAVA="java"
        echo "JAVA_HOME is not set.  Unexpected results may occur."
        echo "Set JAVA_HOME to the directory of your local JDK to avoid this message."
    fi
fi



"$JAVA" \
  -Dpf.server.default.dir="$DEFAULT_DIR" \
  -Dpf.home="$PF_ROOT" \
  -Dpingfederate.log.dir="$PF_ROOT/log" \
  -Drun.properties="$runprops" \
  -Dlog4j.configurationFile="file:///$PF_ROOT/bin/configkeymgr.log4j2.xml" \
  -cp "$CLASSPATH" com.pingidentity.console.configkeymgr.ConfigKeyManager "$@"
