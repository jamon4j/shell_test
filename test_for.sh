#!/bin/sh
if false;then
Sum=0
for((i=1;i<100;i++))
do 
   let "Sum+=i"
done
echo "SUM=$Sum"


for i in {1..10}
do
    echo $i
done

count=0
for i in $(seq 0 1 100)
do 
    if((i%2==0))
    then
	let "count+=i"
    continue
    fi
done
echo "Count=$count"

sum2=0
for((i=1;;i++))
do
   let "sum2+=i"
   if [ "$sum2" -gt 2000 ];then 
	echo "i=$i"
	echo "sum2=$sum2"
	break
   fi
done 

times=0
for i in $(seq 1 100)
do 
    let "times++"
    if ((i%3==0));then
	printf "$i "
   	 if ((times%8==0))
   	 then 
		printf "\n"
   	 fi
    fi
done
printf "\n"

temp=0
for((i=1;i<=9;i++))
do
   for((j=1;j<=9;j++))
   do
	let "temp=$i*$j"
	echo -n "$temp=$i*$j "
   done
   printf "\n"
done
fi

Number()
{
    let "dir_num=0"
    let "file_num=0"
    
    ls
    echo ""
    
    for file in 'ls'
    do
	if [ -d "$file" ]
        then 
  	     let "dir_num+=1"
        elif [ -f "$file" ]
        then
	     let "file_num+=1"
        fi
   done
    
   echo "The number of dirs is $dir_num"
   echo "The number of dirs is $file_num"
}
Number

exit 0
