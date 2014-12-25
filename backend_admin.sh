#!/bin/sh
echo "上线开始"

tomcat_path=/home/www/apache-tomcat-7.0.42
deploy_path=/home/www/publish
project_path=/data/projects/backend_admin
package_path=$project_path/target/mvn_vm_web-1.0-SNAPSHOT
backup_path=/data/backup/projects/backend_admin
export PATH

echo "==============备份旧发布文件=============="
DATE=$(date +%Y%m%d%H%M%S)
cp -rf $deploy_path/backend_admin $backup_path/backend_admin.$DATE
echo "==============备份旧发布完成=============="

echo "==============拉取新程序=============="
cd $project_path;
git reset --hard HEAD
git pull

echo "==============拉取新程序完成=============="

echo "==============编译=============="
mvn clean install
if [ $? != 0 ]; then
	echo "mvn error"
	exit 1
fi
echo "==============编译完成=============="

echo "==============替换配置文件=============="

cp -r ${package_path}/WEB-INF/classes/api_online.properties ${package_path}/WEB-INF/classes/api.properties
cp -r ${package_path}/WEB-INF/classes/conf_online.properties ${package_path}/WEB-INF/classes/conf.properties

echo "==============替换配置完成=============="

echo "==============开始发布（停服务 -> Copy发布文件 -> 启动服务）=============="
${tomcat_path}/bin/catalina.sh stop
cp -fr $package_path $deploy_path
${tomcat_path}/bin/catalina.sh start
echo "发布成功"

