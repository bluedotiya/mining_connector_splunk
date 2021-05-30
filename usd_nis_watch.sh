#!/bin/bash

#Get the currency ratio between the USD (American dollar) and NIS (Israeli new shekel)

#Constant
usd_to_nis=$(curl https://www.boi.org.il/en/Markets/ExchangeRates/Pages/Default.aspx 2> /dev/null | grep -A 1 "<td class=\"BoiExchangeRateCountry\">USA</td>" | grep "\."  | cut -d \> -f2 | cut -d \< -f1)


echo $usd_to_nis > /var/tmp/stats_usd_to_nis
