#!/bin/sh
#Author:zjj
#Date:2014/11/26 16:30
#Desc:检测浮点数的合法性。参数：1个浮点数 合法性： 不支持科学表示法，支持带符号  -1.2  -.75均合法。
#Method：

checkFloat()
{
   float=$1
   max=$2
   min=$3

   if [ -z $1 ];then
      echo "please input a float number!"
      return 1
   fi

   if [ ${float%${float#?}} = "-" ];then
	signed="-"
	float=${float#?}
   fi

   if [ -z $(echo $float | sed 's/[^.]//g') ];then
        echo "without symbol '.' !"
	return 1
   fi
   integer=$(echo $1 | cut -d. -f1)
   decimal=$(echo $1 | cut -d. -f2)

<<BLOCK
   if [ -n $(echo $integer | sed 's/[[:digit:]]//g') ];then
  	echo "the float include nonnumeric character"
  	return 0
   fi

   
   if [ -n $(echo $decimal | sed 's/[[:digit:]]//g') ];then
	echo "the float include nonnumeric character"
	return 0
   fi
BLOCK

   flag=0
   ### echo "float..:1.$integer"

   #整数为空则置为0
   if [ -z $integer ];then
	integer=0
   else
      	#调用整数合法性判断
       	bash ./integerValidationCheck.sh $integer
	if [ $? -eq 1 ];then
		flag=1
	fi
   fi  

   #小数为空，非法
   if [ -z $decimal ];then
        echo "the decimal shouldn't be empty!"
	return 1
   fi

   #若小数带负号，非法
   if [ ${decimal%${decimal#?}} = "-" ];then
	echo "the decimal part should be non negative"
	return 1
   fi

   #判断小数部分是否为合法整数
   bash ./integerValidationCheck.sh $decimal
   if [ $? -eq 1 ];then
	flag=1
   fi

   if [ $flag -eq 0 ];then
 	return 0
   else 
	return 1
   fi
}

if checkFloat $1 $2 $3;then
    echo "$1 is valid!"
fi

exit 0
