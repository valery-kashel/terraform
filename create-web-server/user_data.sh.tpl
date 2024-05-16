#!/bin/bash
yum -y update
yum -y install httpd
cat <<EOF > /var/www/html/index.html
<h2>Hello from my web server<h2>
<h2>Owner is ${owner}</h2>
<p>Server was made by: <p>
%{ for x in made_by ~}
<p>${x}<p>
<br>
%{ endfor ~}
EOF
sudo service httpd start
chkconfig httpd on
echo "hello world"