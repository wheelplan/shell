#!/bin/bash


web_dir=/usr/share/nginx

web_ip=106.52.20.164





tar zcf /tmp/${BUILD_ID}_web.tar.gz *

scp /tmp/${BUILD_ID}_web.tar.gz ${web_ip}:/tmp

ssh ${web_ip} "mkdir ${web_dir}/${BUILD_ID}_web"

ssh ${web_ip} "tar xf /tmp/${BUILD_ID}_web.tar.gz -C ${web_dir}/${BUILD_ID}_web && rm -rf ${web_dir}/html"

ssh ${web_ip} "ln -s ${web_dir}/${BUILD_ID}_web ${web_dir}/html"

rm -rf /tmp/${BUILD_ID}_web.tar.gz
