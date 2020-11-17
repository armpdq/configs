#!/bin/bash

cd /proc
total=0
for pid in [0-9]*
do
	count=$(ls /proc/$pid/fd/ | wc -l)
	total=$((total+count))
done

#echo "$total"
echo "$total" > "/etc/nixstats/open-files.txt"
