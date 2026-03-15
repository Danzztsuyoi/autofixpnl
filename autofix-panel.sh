#!/bin/bash

clear

echo "================================"
echo "AUTO FIX VPS PTERODACTYL"
echo "================================"

sleep 2

echo "Memperbaiki APT LOCK..."

killall apt apt-get 2>/dev/null

rm -f /var/lib/dpkg/lock*
rm -f /var/cache/apt/archives/lock
rm -f /var/lib/apt/lists/lock

dpkg --configure -a

echo "Menunggu proses dpkg..."

while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
sleep 2
done

while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 ; do
sleep 2
done

echo "Update repository..."

apt update -y

echo "Install dependency..."

apt install curl wget git sudo -y

echo "Restart service..."

systemctl restart nginx 2>/dev/null
systemctl restart mysql 2>/dev/null
systemctl restart redis-server 2>/dev/null

echo "Stop wings..."

systemctl stop wings 2>/dev/null

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
