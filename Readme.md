# CloudX App

## Install

Copy script from below script section to user-data in aws ec2 configuration step3.

`app_cloudx.conf` - NGINX config file, copy to `/etc/nginx/sites-available/`

`my_service.service` - autorun service with system restart, copy to `/etc/systemmd/system/`

Insert archive file with code (zip) into s3 bucket.

### Script - user data

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