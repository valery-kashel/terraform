#!/bin/bash
yum -y update
yum -y install httpd
echo "<h2>Hello from my web server<h2>" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on