#!/bin/bash

SERVICE="trillium-api-1.0.0-SNAPSHOT"
PID=`ps -ef | grep java | grep $SERVICE | grep -v grep | awk '{print $2}'`

if [ -z $PID ]
then
        echo "$SERVICE has already stopped!"
else
        kill -9 $PID
        echo "$SERVICE has been stopped"
fi
