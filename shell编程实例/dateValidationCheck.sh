#!/bin/sh
#Author:zjj
#Date:2014/11/27 10:30
#Desc:检测日期的合法性　1) 参数形式 “month day year”    2） day的合法性。  day 与 month的关系   case-in  闰年：能被4 和400整除为闰年。 若能被4但不能被400整除，若被能被100整除则为闰年. 函数2	3） 输出  month day year, 其中month为单词的前三个字母，第一个大写，其余小写。
#Method：

#检测month的合法性
checkMonth()
{
   case $1 in
   1) month="Jan" ;;
   2) month="Feb" ;;
   3) month="Mar" ;;	
   4) month="Apr" ;;
   5) month="May" ;;
   6) month="Jun" ;;
   7) month="Jul" ;;
   8) month="Aug" ;;
   9) month="sep" ;;
   10) month="Oct" ;;
   11) month="Nov" ;;
   12) month="Dec" ;;
   *) echo "$0:error month number!" >&2;exit 1
   esac

   return 0
}

#检测day的合法性
checkDay()
{
   day=$2
   year=$3

   #判断闰年
   if [ $((year%4==0 && year%100!=0 || year%400==0)) -eq 1 ];then
	isLeap=1
   else
	isLeap=0
   fi
    
   case $1 in
   1) max_day=31 ;;
   2) if [ $isLeap = "1" ];then
	max_day=29
      else
	max_day=28
      fi ;;
   3)  max_day=31;;	
   4)  max_day=30;;
   5)  max_day=31;;
   6)  max_day=30;;
   7)  max_day=31;;
   8)  max_day=31;;
   9)  max_day=30;;
   10) max_day=31;;
   11) max_day=30;;
   12) max_day=31;;
   *) echo "error month number"
      return 1 ;;
   esac

   if [ $((day<1||day>max_day)) -eq 1 ];then
	echo "day is illeagl!it should be between 1 and $max_day!"
  	return 1
   fi

   return 0
}

checkDate()
{
   day=$2
   year=$3
   
   #如果month不是正整数，非法
   if [ -n "$(echo $1 | sed 's/[[:digit:]]//g')" ];then
	echo "month should't include other character but digit"
	return 1
   fi	
	
   #如果day不是正整数，非法
   if [ -n "$(echo $day | sed 's/[[:digit:]]//g')" ];then
	echo "day should't include other character but digit"
	return 1
   fi
	
   #如果year不是正整数，非法
   if [ -n "$(echo $year | sed 's/[[:digit:]]//g')" ];then
	echo "year should't include other character but digit"
	return 1
   fi	

   if checkMonth $1;then
       if checkDay $1 $2 $3;then
          return 0
       else
          return 1
       fi
   else
	return 1
   fi	

}

if checkDate $1 $2 $3;then
    echo "the date is valid!"
    echo "$month $2 $3"
fi

exit 0
