etc/sysconfig/network-scripts/ifcfg-enp0s3

sudo service NetworkManager stop
sudo chkconfig NetworkManager off
hostnamectl set-hostname mysite.darren.com
sudo service network restart
sudo yum install -y perl
cd /home
sudo wget https://securedownloads.cpanel.net/latest
sudo sh latest