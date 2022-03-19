#!/bin/bash
# install tools and packages
apt update
apt install unzip

apt-get install -y nginx
apt-get install -y python3-venv

# prepare environment
mkdir /home/admin/cloudx_app/
aws s3 cp s3://paul-sample-cloudx/flask-sample.zip /home/admin/cloudx_app/
unzip /home/admin/cloudx_app/flask-sample.zip -d /home/admin/cloudx_app/

rm /etc/nginx/sites-enabled/default
cp /home/admin/cloudx_app/app_cloudx.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/app_cloudx.conf /etc/nginx/sites-enabled/app_cloudx.conf
nginx -s reload

#auto restart
cp /home/admin/cloudx_app/my_service.service /etc/systemd/system/
systemctl start my_app.service
systemctl enable my_app.service

#python3 -m venv /home/admin/cloudx_app/env
#/home/admin/cloudx_app/env/bin/python3 -m pip install -r /home/admin/cloudx_app/requirements.txt
#/home/admin/cloudx_app/env/bin/python3 /home/admin/cloudx_app/app.py