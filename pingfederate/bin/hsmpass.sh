#!/usr/bin/env bash

DIRNAME=`dirname "$0"`
ROOT=$DIRNAME/..
DIRNAME=`(cd "$DIRNAME" && pwd)`
# Set DIRNAME_ESC - this is DIRNAME but with spaces that are replaced with %20
DIRNAME_ESC=${DIRNAME// /%20}

ROOT_LIB="$ROOT/lib"
DEFAULT_DIR="$ROOT/server/default"

PASSWORD_FILE="$ROOT/server/default/data/hsmpasswd.txt"

# Read an optional running configuration file
if [ "x$RUN_CONF" = "x" ]; then
    RUN_CONF="$DIRNAME/run.conf"
fi
if [ -r "$RUN_CONF" ]; then
    . "$RUN_CONF"
fi

CLASSPATH="$ROOT_LIB/*"
CLASSPATH="$CLASSPATH:$DIRNAME/*"
CLASSPATH="$CLASSPATH:$DEFAULT_DIR/lib/*"
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

"$JAVA" -Dpf.server.default.dir="$DEFAULT_DIR" \
    -classpath "$CLASSPATH" \
    -Dlog4j.configurationFile="file:///$DIRNAME_ESC/hsmpass.log4j2.xml" \
    -Dpassword.file="$PASSWORD_FILE" \
    com.pingidentity.console.PasswordChanger HSM "$@"
