#!/bin/bash

# Pragram:
#      Automatic recovery of MHA cluster

# History:
#        2020-02-27    Alan        First release

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/application/mysql/bin

export PATH

mha_log=/etc/mha/app1/manager.log
change=`grep -io 'change master.*;' $mha_log | sed 's#xxx#linux#'`
down_master=$(sed -nr 's#^Master (.*)\(.*\!$#\1#gp' ${mha_log})


ssh $down_master "systemctl start mysqld"

sleep 2

mysql -umha -pmha -h $down_master -e "${change}start slave;"

\cp /etc/mha/app1.cnf.ori /etc/mha/app1.cnf

nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /etc/mha/app1/manager.log 2>&1 &
