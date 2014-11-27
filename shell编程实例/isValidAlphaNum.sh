#!/bin/sh
#Author:zjj
#Date:2014/11/25 14:00
#Desc:验证用户输入是否合法，要求串由大小写字母、数字组成，无标点、特殊符号、空格
#Method：将输入的串中 非字母数字的内容删除或替换为空后若和原来输入的相同则合法，否则不合法。

checkValid()
{
   #[[:alnum:]]表示所有字母和数字中的任一个字符
   compressed="$(echo $1|sed 's/[^[:alnum:]]//g')"
   if [ "$compressed" != "$1" ];then
	echo "invalid"
	return 1
   else 
	echo "valid"
	return 0
   fi
}
echo -n "Enter input:"
read input

checkValid "$input"

exit
