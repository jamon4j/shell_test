#!/bin/sh

read -p 'input 1st str ' str1
read -p 'input 2nd str ' str2

if [ "$str1" = "$str2" ];then
 echo "equal"
else
 echo "not equal"
fi

[ -n "$str1" ]
echo $?

[ -d /home/zhangjiajiang/test/deleteMe ]
echo $?
exit

