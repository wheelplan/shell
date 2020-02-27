#!/bin/bash

# Pragram:
#      Automatic recovery of MHA cluster

# History:
#        2020-02-27    Alan        First release

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

export PATH

mha_log=/etc/mha/app1/manager.log
change=`grep -io 'change master.*;' $mha_log | sed 's#xxx#linux#'`
down_master=`echo $change | egrep -o [0-9][0-9.]{6\,14}`


ssh $down_master "systemctl start mysqld"

mysql -umha -pmha -h $down_master -e "${change}start slave;"

\cp /etc/mha/app1.cnf.ori /etc/mha/app1.cnf
