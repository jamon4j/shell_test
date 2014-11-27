#!/bin/sh
#Author:zjj
#Date:2014/11/26 16:00
#Desc:检测 输入整数的合法性，可负数（-1, -2均合法）， 可以指定传入整数范围，不在范围内则报错,　　参数：1或3个， 当3个时，后两个为范围。
#Method：

checkValidation()
{
   integer=$1
   min=$2
   max=$3

  ### echo "check..:1.$integer"
 
   if [ -z "$1" ];then
	echo "please input the number!"
	return 1
   fi	
 
   #判断负数，若为负数去掉符号再判断整数
   if [ "$(echo $1 | cut -c1)" = "-" ];then
	signed="-"
	integer=${integer#?} #删除掉符号
   fi
   
   #只有符号位，非法
   if [ -z "integer" ];then
      echo "Invalid input,just a "-" is not allowed">&2
      return 1
   fi

   #整数部分包含非数字，非法
   if [ -n "$(echo $integer | sed 's/[[:digit:]]//g')" ];then
	echo "invalid input, it includes some char but digit">&2
	return 1
   fi     

   #判断范围，超出范围非法
   if [ $integer -lt ${min:=$integer} ];then
	echo "$integer is too small,it should greater than $min">&2
	return 1
   fi

   if [ $integer -gt ${max:=$integer} ];then
	echo "$integer is too large,it should little than $max">&2
	return 1 
   fi

   return 0
}

if checkValidation $1 $2 $3;then
    #echo "your input is valid"
    exit 0
fi

exit 1
