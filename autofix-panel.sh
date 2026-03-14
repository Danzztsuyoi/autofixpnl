#!/bin/bash

clear

echo "================================"
echo "AUTO FIX VPS PTERODACTYL"
echo "================================"

sleep 2

apt update -y
apt upgrade -y

apt install curl wget git sudo -y

systemctl restart nginx 2>/dev/null
systemctl restart mysql 2>/dev/null
systemctl restart redis-server 2>/dev/null

systemctl stop wings 2>/dev/null

docker system prune -a -f 2>/dev/null

rm -rf /var/www/pterodactyl
rm -rf /etc/pterodactyl
rm -rf /var/lib/pterodactyl

mkdir -p /var/www
chmod 755 /var/www

echo "AUTO FIX SELESAI"
