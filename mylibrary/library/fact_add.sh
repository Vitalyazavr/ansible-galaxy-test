#!/bin/bash
source $1
filename=${filename:-custom_fact}
fdir=${fdir:-/etc/ansible/facts.d}
if [[ ! -z $key ]] || [[ ! -z $value ]]
then
	[[ ! -d $fdir ]] | mkdir -p $fdir
	if [[ ! -s $fdir"/"$filename".fact" ]]
	then
		echo {\"$key\": \"$value\"} > $fdir"/"$filename".fact"
		echo { \"changed\": true }
    	exit 0
	else
  		sed -i "s^}^\, \"$key\": \"$value\"}^" $fdir"/"$filename".fact"
		echo { \"changed\": true }
    	exit 0
	fi
else
  	echo { \"failed\": true }
  	exit 0
fi