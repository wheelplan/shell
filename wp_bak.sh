#!/bin/bash

# Pragram:
#	备份 wordpress

# History:
#        2020-01-27    Alan        First release

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

export PATH

# 定义目录变量
path=/backup
host=`hostname`
ip=`curl ifconfig.me -s`
date=`date +%F`
dest=${host}_${ip}_${date}
dest_ip=193.112.70.157

# 创建备份目录
mkdir -p ${path}/${dest}

# 打包备份文件
tar zcf ${path}/${dest}/nginx_conf.tar.gz /etc/nginx &> /dev/null
tar zcf ${path}/${dest}/www_code.tar.gz /www/ &> /dev/null
mysqldump -uroot -plinux --databases wordpress > ${path}/${dest}/wp.sql

# 推送至目标服务器
ssh ${dest_ip} 'mkdir -p /backup'
scp -r /${path}/${dest} ${dest_ip}:${path}

# 删除 15 天前的数据
find ${path} -mtime +15 | xargs rm -rf
ssh ${dest_ip} 'find /backup -mtime +15 | xargs rm -rf'
