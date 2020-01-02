#!/bin/bash

# Add certbot repository
add-apt-repository ppa:certbot/certbot -y
# Update package lists
apt-get update
# Upgrade existing packages
apt-get upgrade -y
# Install nginx
apt-get install nginx -y

# Get domain name and email address for Let's encrypt certificate
while true
do
    read -p "Enter the fqdn for your domain: " website
    echo
    read -p "Confirm the fqdn for your domain: " website2
    echo
    [ "$website" = "$website2" ] && break
    echo "Domains don't match. Please try again."
    echo
done
echo
while true
do
    read -p "Enter your email address: " certbotemail
    echo
    read -p "Confirm your email address: " certbotemail2
    echo
    [ "$certbotemail" = "$certbotemail2" ] && break
    echo "Email addresses don't match. Please try again."
    echo
done

guacamoleurl=http://localhost:8080/guacamole/

# Configure /etc/nginx/sites-available/(website name)
cat >/etc/nginx/sites-available/$website <<EOL
server {

    listen 80 default_server;
    listen [::]:80 default_server;
    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
    server_name $website www.$website;
    location / {
        proxy_pass $guacamoleurl;
        proxy_buffering off;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$http_connection;
        access_log off;
    }

}
EOL

# symlink from sites-available to sites-enabled
ln -s /etc/nginx/sites-available/$website /etc/nginx/sites-enabled/
# make sure default is unlinked
unlink /etc/nginx/sites-enabled/default

service apache2 stop
systemctl start nginx

#add-apt-repository ppa:certbot/certbot -y
#apt-get update
apt install python-certbot-nginx -y
certbot --nginx -n -d $website -d www.$website --email $certbotemail --agree-tos --redirect --hsts
