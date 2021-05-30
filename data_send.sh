#!/bin/bash

#config
miner_name=""  #set the desiered miner name (if you have multiple miners can be useful)
miner_logs_path="" #Path the temporary script will be saved
miner_helper_scripts_path="" # Path to helper scripts folder
splunk_HTTP_Connector_Token=""
splunk_machine_ip_port="ip:8088"  #Default port is 8088
stats_data_path="/var/tmp"  # Path to the data files on simplemining OS this is found on /var/tmp
data_list="stats_sys_ipLAN\|stats_hash\|stats_sys_pwr\|stats_gpu_temp_jq\|stats_sys_uptime\|stats_eth_price\|stats_wei_daily\|stats_wei_unpaid\|stats_usd_to_nis"
sleep_offset=0 # if the script is commited by Crontab this can help pick which script will execute first. (In seconds)

sleep $sleep_offset

#Constants
timestamp=$(date +%Y-%m-%dT%H:%M:%S)  # This Timestamp the logs to splunk

#helper scripts that are desgined to get external values from Pools or Currency API, Disabled by Default
#bash $miner_helper_scripts_path/eth_price_watch.sh
#bash $miner_helper_scripts_path/wei_daily_rev.sh
#bash $miner_helper_scripts_path/wei_unpaid_balance.sh
#bash $miner_helper_scripts_path/usd_nis_watch.sh

# Test if folder exist if not creates one.
if [ -d "$miner_logs_path" ] 
then test
else
	mkdir $miner_logs_path
fi
# Gets all the hardware stats from tmp folder and run in a for each loop.
echo "miner_name=$miner_name" >> $miner_logs_path/miner_$timestamp.log
for i in $(ls $stats_data_path | grep $data_list | grep -v ".sent") 
do
echo -n "$i=\"" >> $miner_logs_path/miner_$timestamp.log
if [[ "$i" =~ "jq" ]] # check if data file is JSON Format
then
	echo $(cat "$stats_data_path/$i" | jq -r '."0"')\" >> $miner_logs_path/miner_$timestamp.log
else
	echo $(cat "$stats_data_path/$i")\" >> $miner_logs_path/miner_$timestamp.log
fi
done

status_code=$(curl -m 5  -k  https://$splunk_machine_ip_port/services/collector/raw -H "Authorization: Splunk $splunk_HTTP_Connector_Token" -F "$miner_name=@$miner_logs_path/miner_$timestamp.log") 2> /dev/null
if [ $status_code = '{"text":"Success","code":0}' ] # if sending is successful deletes local log, if not keep it
then
	rm "$miner_logs_path/miner_$timestamp.log"
	echo "true"
else
	echo "false"
fi


