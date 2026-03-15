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

echo "Removing docker containers..."

docker rm -f $(docker ps -aq) 2>/dev/null
docker system prune -af 2>/dev/null

echo "Removing panel files..."

rm -rf /var/www/pterodactyl
rm -rf /etc/pterodactyl
rm -rf /var/lib/pterodactyl

echo "Removing wings..."

rm -f /usr/local/bin/wings
rm -f /etc/systemd/system/wings.service

systemctl daemon-reload

echo "Removing database..."

mysql -u root -e "DROP DATABASE IF EXISTS panel;" 2>/dev/null
mysql -u root -e "DROP USER IF EXISTS 'admin'@'127.0.0.1';" 2>/dev/null
mysql -u root -e "DROP USER IF EXISTS 'admin'@'localhost';" 2>/dev/null

echo "Restarting nginx..."

systemctl start nginx 2>/dev/null

echo "================================"
echo "PANEL BERHASIL DIHAPUS"
echo "================================"
