#!/bin/bash

#config
miner_name=""
miner_logs_path=""
splunk_HTTP_Connector_Token=""
splunk_machine_ip_port="ip:8088"  #Default port is 8088
sleep_offset=10  #offset is 10 seconds so its will always run after data_send script.

sleep=$sleep_offset

if [ -d $miner_logs_path ] # check if folder exist, if not creates one.
then test
else
	mkdir $miner_logs_path
fi

for i in $(ls $miner_logs_path)  # Running a foreach loop for all files in folder and sends them for splunk, if successful remove the temporay file if not echo false.
do 
status_code=$(curl -m 5  -k  https://$splunk_machine_ip_port/services/collector/raw -H "Authorization: Splunk $splunk_HTTP_Connector_Token" -F "$miner_name=@$miner_logs_path/$i") 2> /dev/null
if [ $status_code = '{"text":"Success","code":0}' ]
then
        rm "$miner_logs_path/$i"
        echo "True On $i"
else
        echo "False On $i"
fi
done
