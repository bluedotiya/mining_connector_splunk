#!/bin/bash

# This script gets the estimated wei revanue value from you flexpool miner, use it if you have flexpool

#Constant
wallet_address=""
wei_get_daily=$(curl -X GET "https://flexpool.io/api/v1/miner/$wallet_address/estimatedDailyRevenue/" | cut -d : -f3 | cut -d \} -f1)

echo $wei_get_daily > /var/tmp/stats_wei_daily
