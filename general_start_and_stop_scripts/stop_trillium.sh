grep_result_status=0
ps -ef | grep java | grep trillium-api-1.0.0-SNAPSHOT.jar | grep -v grep
grep_result_status=$?
if [ $grep_result_status -eq 0 ]
then
        echo ""
        kill -9 $(ps -ef | grep '[j]ava' | grep '[t]rillium-api-1.0.0-SNAPSHOT.jar' | awk '{print $2}')
        echo " Stopped the above process running"
else
        echo "Service is already stopped !"
fi
