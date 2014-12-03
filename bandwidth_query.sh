#!/bin/sh
#批量导入email，根据每一个email查询带宽，生成结果文件

#暂存user_id,tenant_id的临时文件
temp=/root/zjj/temp_file

#需要查询的email所在文件
email_file=/root/zjj/email_file

#存放查询结果的目录
target_directory=/root/zjj/bandwidth_repertory2

#逐个读取email并到数据库查询结果
cat email_file | while read email
do
     touch $target_directory/$email     #创建结果存放文件

     target_file=$target_directory/$email  

     sql_select="select id from user where extra like '%$email%';"
     
     mysql -h 10.3.1.201 -ustatapp -pAXvD23Zt0hkEozd4 -D keystone -e "${sql_select}" > $temp
     
     user_id=$(cat $temp | sed '1d')
     
     sql_select="select tenant_id from user_tenant_membership where user_id = '$user_id';"
     
     mysql -h 10.3.1.201 -ustatapp -pAXvD23Zt0hkEozd4 -D keystone -e "${sql_select}" > $temp
     
     tenant_id=$(cat $temp | sed '1d')
     
     sql_select="select id,floating_ip_address,fixed_ip_address,device_id,created_at from floatingips where tenant_id = '$tenant_id';"
     
     mysql -h 10.146.1.82 -ustatapp -pAXvD23Zt0hkEozd4 -D neutron -e "${sql_select}" >$target_file
     
     sed -i '1d' $target_file	#删除字段名
done

exit 0
