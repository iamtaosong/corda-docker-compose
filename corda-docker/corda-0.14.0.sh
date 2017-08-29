#!/bin/bash

export NODE_NAME="${NODE_NAME-NoNameNode}"
export DEBUG_PORT="${DEBUG_PORT-5005}"
export JAVA_OPTIONS="${JAVA_OPTIONS--Xmx512m}"
export JAVA_DCAPSULE="${JAVA_DCAPSULE--agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=$DEBUG_PORT}"
export JAVA_DNAME="${JAVA_DNAME-$NODE_NAME-corda.jar}"

exec java $JAVA_OPTIONS -Dname="$JAVA_DNAME" -Dcapsule.jvm.args="$JAVA_DCAPSULE" -jar /opt/corda/corda.jar --log-to-console --logging-level=INFO