#!/bin/bash

# corda-webserver depends on corda
#sv start corda || exit 1

# wait for keystore/truststore files
while [ ! -f /etc/service/corda-webserver/certificates/sslkeystore.jks ]
do
  sleep 5
  echo "Waiting for /etc/service/corda-webserver/certificates/sslkeystore.jks to show up. (in dev, the file is auto-generated when starting corda)"
done
echo "Found `ls /etc/service/corda-webserver/certificates/sslkeystore.jks`"
echo "Proceeding to start corda-webserver..."
sleep 2

export NODE_NAME="${NODE_NAME-NoNameNode}"
export DEBUG_PORT="${WS_DEBUG_PORT-5006}"
export JAVA_OPTIONS="${WS_JAVA_OPTIONS--Xmx512m}"
export JAVA_DCAPSULE="${WS_JAVA_DCAPSULE--agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=$DEBUG_PORT}"
export JAVA_DNAME="${WS_JAVA_DNAME-$NODE_NAME-corda-webserver.jar}"

exec java $JAVA_OPTIONS -Dname="$JAVA_DNAME" -Dcapsule.jvm.args="$JAVA_DCAPSULE" -jar /opt/corda/corda-webserver.jar --log-to-console --logging-level=INFO