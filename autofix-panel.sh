#!/bin/bash

clear

echo "================================"
echo "AUTO FIX VPS PTERODACTYL"
echo "================================"

sleep 2

echo "Menghentikan proses apt/dpkg..."

killall apt apt-get dpkg 2>/dev/null

rm -f /var/lib/dpkg/lock-frontend
rm -f /var/lib/dpkg/lock
rm -f /var/cache/apt/archives/lock

dpkg --configure -a

echo "Menunggu dpkg selesai..."

while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
sleep 2
done

while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 ; do
sleep 2
done

echo "Update sistem..."

apt update -y
apt upgrade -y

echo "Install dependency..."

apt install curl wget git sudo -y

echo "Restart service..."

systemctl restart nginx 2>/dev/null
systemctl restart mysql 2>/dev/null
systemctl restart redis-server 2>/dev/null

echo "Stop wings..."

systemctl stop wings 2>/dev/null

echo "Membersihkan database lama..."

mysql -u root -e "DROP DATABASE IF EXISTS panel;" 2>/dev/null
mysql -u root -e "DROP USER IF EXISTS 'admin'@'127.0.0.1';" 2>/dev/null
mysql -u root -e "DROP USER IF EXISTS 'admin'@'localhost';" 2>/dev/null
mysql -u root -e "DROP USER IF EXISTS 'pterodactyl'@'127.0.0.1';" 2>/dev/null
mysql -u root -e "DROP USER IF EXISTS 'pterodactyl'@'localhost';" 2>/dev/null

echo "Membersihkan docker..."

docker system prune -a -f 2>/dev/null

echo "Menghapus panel lama..."

rm -rf /var/www/pterodactyl
rm -rf /etc/pterodactyl
rm -rf /var/lib/pterodactyl

mkdir -p /var/www
chmod 755 /var/www

echo "================================"
echo "AUTO FIX SELESAI"
echo "================================"
