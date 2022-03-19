#!/bin/bash

apt update
apt install unzip

mkdir /home/admin/cloudx_app/
echo " >>> Copy file from S3 bucket"
aws s3 cp s3://paul-sample-cloudx/flask-sample.zip /home/admin/cloudx_app/
unzip /home/admin/cloudx_app/flask-sample.zip -d /home/admin/cloudx_app/
echo " >>> Copy file my_service.service to systemmd"
cp /home/admin/cloudx_app/my_service.service /etc/systemd/system/my_service.service

echo " >>> Install nginx"
apt-get install -y nginx
apt-get install -y python3-venv
python3 -m venv /home/admin/cloudx_app/env
/home/admin/cloudx_app/env/bin/python3 -m pip install -r /home/admin/cloudx_app/requirements.txt
rm /etc/nginx/sites-enabled/default
cp /home/admin/cloudx_app/app_cloudx.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/app_cloudx.conf /etc/nginx/sites-enabled/app_cloudx.conf
nginx -s reload

#auto restart
echo " >>> Run service"
systemctl start my_service.service
systemctl enable my_service.service