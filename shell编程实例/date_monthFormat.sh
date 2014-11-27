#Author:zjj
#Date:2014/11/25 14:00
#Desc:输入一个 “month day year”格式的日期串，程序将处理” month”为 其英文单词的前三个字母，第一个字母大写，其余的小写
#Method：首先判断month是数字、还是单词，若是数字，则可查“数字—month”映射表（自定义case结构）；若是单词，则取前三个字母，并格式化。

monthFormat()
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
   9) month="Sep" ;;
   10) month="Oct" ;;
   11) month="Nov" ;;
   12) month="Dec" ;;
   *) echo "$0:Unknown numeric month value $1" >&2; exit 1
   esac
   return 0
}

if [ $# -ne 3 ];then
   echo "Usage: $0 month day year" 
   exit 1
fi

if [ -n "$(echo $1 | sed 's/[[:alnum:]]//g')" ];then
	echo "月份只能包含字母或数字"
	exit 1
fi

if [ -z "$(echo $1 | sed 's/[[:digit:]]//g')" ];then
	monthFormat $1
else
	month="$(echo $1 | cut -c 1 | tr '[:lower:]' '[:upper:]')"
	month="$month$(echo $1 | cut -c 2-3 | tr '[:upper:]' '[:lower]')"
fi

echo $month $2 $3
exit 0
