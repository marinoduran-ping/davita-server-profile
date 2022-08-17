#!/usr/bin/env bash

DIRNAME=`dirname "$0"`/..
DIRNAME=`(cd "$DIRNAME" && pwd)`
# Set DIRNAME_ESC - this is DIRNAME but with spaces that are replaced with %20
DIRNAME_ESC=${DIRNAME// /%20}

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

CLASSPATH="$DIRNAME/bin/pf-consoleutils.jar:$DIRNAME/server/default/lib/*"

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

"$JAVA" -cp "$CLASSPATH" -Dpingfederate.log.dir="$DIRNAME/log" -Dlog4j.configurationFile="file:///$DIRNAME_ESC/bin/logfilter.log4j2.xml" -Drun.properties="$runprops" com.pingidentity.console.logfilter.utility.LogFilterUtility "$@"
