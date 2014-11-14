#!/bin/sh

echo "input a year"
read year

if [ $[$year%4] -eq 0 -a $[$year%100] -ne 0 -o $[$year%400] -eq 0 ];then
	echo "$year is leap year"
else 	
	echo "$year is not leap year"
fi

exit
