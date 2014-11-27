#Author:zjj
#Date:2014/11/25 14:00
#Desc:格式化输出 大数字，使输出结果更容易让人知道该输出数字的数量级。　　默认用>逗号分隔整数部分，用点号分隔整数与小数部分，当然用户也可以使用 –d 指定整数的分隔符，用-t指定　　整数与小数部分的分隔符.算法： 1232342142.423023  ==> 默认：1,232,342,142.423023
#Method：

numberFormat()
{
    integer=$(echo $1 | cut -d. -f1)
    decimal=$(echo $1 | cut -d. -f2)

    #处理小数部分
    if [ -n $decimal ];then
        if [ -z $DD ];then
                DD=.
        fi
        result="$DD$decimal"
    fi
    
    
    numPart=$integer
    #处理整数部分，每三位处理一次
    while [ $numPart -gt 999 ]
    do
        remainder=$(($numPart%1000))
        while [ ${#remainder} -lt 3 ];do
                remainder=0$remainder
        done

        numPart=$(($numPart/1000))
        if [ -z $TD ];then
                TD=,
        fi
        result="$TD$remainder$result"
    done

    if [ -n $numPart ];then
        result="$numPart$result"
   # elif [ ${result%${result#?}} = "$TD" ];then
   #	result="${result#?}"
   # else
   #     result="echo $result | sed '1s/$TD//'" #去掉头部多余的,
    fi
    echo $result
}

if [ $# -eq 0 ];then
   echo "please input parameter"
   exit 1
fi

#处理输入的自定义分割符
while getopts "d:t:" opt
do
    case $opt in
        d) DD="$OPTARG" ;;
        t) TD="$OPTARG" ;;
        *) echo "no arg-flag:$opt" >$2 ; exit 1
    esac
done
#移动到目标参数
shift $(($OPTIND - 1))

numberFormat $1
exit 0

