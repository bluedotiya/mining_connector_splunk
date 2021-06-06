#!/bin/bash

# This script gets the unpaid wei value from you flexpool miner, use it if you have flex pool

#Constant
wallet_address=""
output_path="/var/tmp"
wei_unpaid=$(curl -X 'GET'   "https://api.flexpool.io/v2/miner/balance?coin=eth&address=$wallet_address&countervalue=USD" | cut -d : -f4 | cut -d , -f1)


echo "$wei_unpaid" > $output_path/stats_wei_unpaid
