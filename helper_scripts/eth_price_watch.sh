#!/bin/bash

#This script gets ETHUSDT Price from Binance API

#Constants
output_path="/var/tmp"
eth_price=$(curl -X GET https://api.binance.com/api/v3/avgPrice?symbol=ETHUSDT  2> /dev/null | cut -d : -f3 | cut -d \" -f2)
trimmed_price=${eth_price:0:8}


echo $trimmed_price > $output_path/stats_eth_price
echo $trimmed_price
