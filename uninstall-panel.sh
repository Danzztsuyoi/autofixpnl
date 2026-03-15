#!/bin/bash

clear
echo "================================"
echo "UNINSTALL PANEL PTERODACTYL"
echo "================================"

sleep 2

echo "Stopping services..."

systemctl stop wings 2>/dev/null
systemctl stop pteroq 2>/dev/null
systemctl stop nginx 2>/dev/null
systemctl stop redis-server 2>/dev/null

echo "Removing cron pterodactyl..."

crontab -l 2>/dev/null | grep -v pterodactyl | crontab -

echo "Removing docker containers..."

docker rm -f $(docker ps -aq) 2>/dev/null
docker system prune -af 2>/dev/null

echo "Removing panel files..."

rm -rf /var/www/pterodactyl
rm -rf /etc/pterodactyl
rm -rf /var/lib/pterodactyl

echo "Removing wings..."

systemctl disable wings 2>/dev/null
rm -f /usr/local/bin/wings
rm -f /etc/systemd/system/wings.service

systemctl daemon-reload

echo "Removing nginx panel config..."

rm -f /etc/nginx/sites-enabled/pterodactyl.conf
rm -f /etc/nginx/sites-available/pterodactyl.conf

echo "Removing database..."

mysql -u root -e "DROP DATABASE IF EXISTS panel;" 2>/dev/null
mysql -u root -e "DROP USER IF EXISTS 'admin'@'127.0.0.1';" 2>/dev/null
mysql -u root -e "DROP USER IF EXISTS 'admin'@'localhost';" 2>/dev/null
mysql -u root -e "DROP USER IF EXISTS 'pterodactyl'@'127.0.0.1';" 2>/dev/null
mysql -u root -e "DROP USER IF EXISTS 'pterodactyl'@'localhost';" 2>/dev/null

echo "Cleaning cache..."

apt autoremove -y 2>/dev/null

echo "Restarting services..."

systemctl start nginx 2>/dev/null
systemctl restart mysql 2>/dev/null
systemctl restart redis-server 2>/dev/null

echo "================================"
echo "PANEL BERHASIL DIHAPUS"
echo "VPS SIAP INSTALL ULANG PANEL"
echo "================================"
