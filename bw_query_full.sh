#!/bin/sh
#批量导入email，根据每一个email查询带宽，生成结果文件
#脚本需要4个参数分别是:地区（1表示北京，2表示上海）,查询的起始时间（时间戳），查询的终止时间（时间戳），是否计算共享带宽（1表示计算）


temp=/data/bw/tempFile  #暂存user_id,tenant_id的临时文件

dateName=$(date +%Y%m%d)	#需要查询当日日期创建文件夹
bjEmail_file=/data/bw/BJ_emailFile #需要查询的email所在文件(输入)
shEmail_file=/data/bw/SH_emailFile 

data_shResultDirectory=/data/bw/shCalBwResult #存放查询结果的目录（输出）
data_bjResultDirectory=/data/bw/bjCalBwResult

region=$1   #选择查询的地区（1表示北京，2表示上海）

#查询的起止时间（时间戳）
start_time=$2
end_time=$3
share=$4

#北京的查询方式
if [ $region -eq 1 ];then

 if [ ! -d $data_bjResultDirectory/$dateName ];then
    mkdir $data_bjResultDirectory/$dateName
 fi


 echo "----------------------------------------"
 echo "查询北京数据，读取email文件并查询数据库..."
 #while循环体#
 #逐个读取email并到数据库查询结果
 cat $bjEmail_file | while read email
 do

 echo "读取客户$email的数据中..."
 
 
 sh getDeviceIdFromBJ $email $dateName

 echo "读取客户$email的数据完毕"
 done
 echo "读取email文件所有数据并查询数据库完毕"
 echo "----------------------------------------"
fi
#上海的查询方式
if [ $region -eq 2 ];then
 echo "----------------------------------------"
 echo "查询上海数据，读取email文件并查询数据库..."

 if [ ! -d $data_shResultDirectory/$dateName ];then
    mkdir $data_shResultDirectory/$dateName
 fi

 #while循环体#
 #逐个读取email并到数据库查询结果
 cat $shEmail_file | while read email
 do

 echo "读取客户$email的数据中..."
      #创建文件夹及文件#
      dirName=$email"D"$(date +%Y%m%d%H%M)	#根据时间和email名定义目录名
 
      dir=$data_shResultDirectory/$dateName/$dirName  
 
      mkdir $dir  #在/data/bw/calBwResult/(日期名)下创建一个用户的数据目录
 
      file=$dir/inputEip.data
 
      touch file     #创建结果存放文件
 
      #操作数据库#
      sql_select="select id from user where extra like '%$email%';"
 
      mysql -h 10.3.1.201 -ustatapp -pAXvD23Zt0hkEozd4 -D keystone -e "${sql_select}" > $temp
      
      user_id=$(cat $temp | sed '1d')
 
      sql_select="select tenant_id from user_tenant_membership where user_id = '$user_id';"
      
      mysql -h 10.3.1.201 -ustatapp -pAXvD23Zt0hkEozd4 -D keystone -e "${sql_select}" > $temp
      
      tenant_id=$(cat $temp | sed '1d')
 
      sql_select="select id,floating_ip_address,fixed_ip_address,device_id,created_at from floatingips where tenant_id = '$tenant_id';"
      
      mysql -h 10.146.1.82 -ustatapp -pAXvD23Zt0hkEozd4 -D neutron -e "${sql_select}" >$file
      
      sed -i '1d' $file	#删除字段名

      
 echo "读取客户$email的数据完毕"
 done
 echo "读取email文件所有数据并查询数据库完毕"
 echo "----------------------------------------"
fi


#将数据库查出的Eip的id用于查出带宽并计算
echo "----------------------------------------"
echo "带宽计算中..."
echo "pwd:"
pwd
if [ $region -eq 1 ]; then
    for targetDir in `ls $data_bjResultDirectory/$dateName`
    do
    dir=$data_bjResultDirectory/$dateName/$targetDir
    #计算每个Eip带宽及峰值
    /opt/jdk1.7.0_40/bin/java -jar -Djava.ext.dirs="/www/bw/html/libBJ" /www/bw/html/pullBJ.jar $dir/ $start_time $end_time 
    #计算共享带宽及峰值
    if [ $share -eq 1 ]; then
    echo "calculate share BW"
    /opt/jdk1.7.0_40/bin/java -jar -Djava.ext.dirs="/www/bw/html/libBJ" /www/bw/html/calShareBW.jar $dir/ $start_time $end_time
    fi
done
    echo "北京带宽计算完毕...请查阅文件夹/data/bw/BJ_history_calBwResult/$dateName/$targetDir"
    echo "----------------------------------------"
    #将本次查询结果存入历史文件夹中便于以后回查
    mv /data/bw/bjCalBwResult/* /data/bw/BJ_history_calBwResult
fi

if [ $region -eq 2 ]; then
    for targetDir in `ls $data_shResultDirectory/$dateName`
    do
	dir=$data_shResultDirectory/$dateName/$targetDir
	/opt/jdk1.7.0_40/bin/java -jar -Djava.ext.dirs="/www/bw/html/lib" /www/bw/html/pullSH.jar $dir/ $start_time $end_time 

    #计算共享带宽及峰值
	if [ $share -eq 1 ]; then
	echo "calculate share BW"
	/opt/jdk1.7.0_40/bin/java -jar -Djava.ext.dirs="/www/bw/html/lib" /www/bw/html/calShareBW.jar $dir/ $start_time $end_time
	fi
    done

    echo "上海带宽计算完毕...请查阅文件夹/data/bw/SH_history_calBwResult/$dateName/$targetDir"
    echo "----------------------------------------"
    #将本次查询结果存入历史文件夹中便于以后回查
  mv /data/bw/shCalBwResult/* /data/bw/SH_history_calBwResult
fi

exit 0
