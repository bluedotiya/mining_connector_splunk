#!/bin/bash

# This script gets the unpaid wei value from you flexpool miner, use it if you have flex pool

#Constant
wallet_address=""

wei_unpaid=$(curl -X GET "https://flexpool.io/api/v1/miner/$wallet_address/balance/" | cut -d : -f3 | cut -d \} -f1)


echo $wei_unpaid > /var/tmp/stats_wei_unpaid
