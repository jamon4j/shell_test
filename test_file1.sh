#!/bin/sh

read -p "input a string: " str

if [ -d $str ];then
 ls $str
elif [ -f $str ];then
 cat $str
else
 echo "input error!"
fi

exit
