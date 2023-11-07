#!/bin/bash

# Get base script dir for execution
BASEDIR=$(dirname $(readlink -f $0))

# Get curent host IP
HOSTIP=$(hostname -i)

#export JAVA_HOME=/appl/jdk1.8.0_271/jre
export JAVA_HOME=/appl/Java17
export PATH=$JAVA_HOME:$JAVA_HOME/bin:$PATH

echo $CLASSPATH

java -jar -Dtrillium_logger_path=/appl/trilapi/logs -Dserver.ssl.enabled-protocols=TLSv1.2 -Djasypt.encryptor.password=TRILLIUM_JASYPT_TOKEN -Dspring.profiles.active=qa trillium-api-1.0.0-SNAPSHOT.jar > ${BASEDIR}/start_auto.log &
