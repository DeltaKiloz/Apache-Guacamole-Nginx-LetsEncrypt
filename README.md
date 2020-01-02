# Apache-Guacamole-Nginx-LetsEncrypt
This script helps install Apache Guacamole (tested on Ubuntu 18.04 LTS server) with an Nginx reverse proxy and Let's Encrypt SSL certificate.

Use the nginx-guac-install.sh first so that you can troubleshoot any issues related to the Let's Encrypt installation you might come across, which typically is firewall issues.

The guac-install.sh script will also install the latest Java JDK 8 which is the only major prerequisite required. 

Much of this was taken from the following repos, but customized furher based on my personal preferences:

https://github.com/MysticRyuujin/guac-install

https://github.com/jasonvriends/guacamole
