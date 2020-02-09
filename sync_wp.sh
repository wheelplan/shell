#!/bin/bash

# Pragram:
#	Sync wordpress

# History:
#        2020-02-02    Alan        First release

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

export PATH

# 同步 wps 文件数据
rsync -av /www/wordpress/wp-content/ 193.112.70.157:/share/pv-wordpress/wp-content

# 同步数据库
mysqldump -uroot -plinux --databases wordpress > /tmp/wp.sql
mysql -uroot -plinux -h 193.112.70.157 < /tmp/wp.sql
mysql -uroot -plinux -h 193.112.70.157 -e "use wordpress;\
UPDATE wp_options SET option_value = REPLACE(option_value, 'https://rocc.top', 'http://123.207.124.79:511') WHERE option_name = 'home' OR option_name = 'siteurl';\
UPDATE wp_posts SET post_content = REPLACE(post_content, 'https://rocc.top' , 'http://123.207.124.79:511');\
UPDATE wp_posts SET guid = REPLACE(guid, 'https://rocc.top' ,'http://123.207.124.79:511');"

pod=`ssh 193.112.70.157 kubectl get po | awk '/wordpress-mysql/{print $1}'`
ssh 193.112.70.157 kubectl delete po ${pod}
