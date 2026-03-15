#!/bin/bash

clear

echo "================================"
echo "PTERODACTYL BOT TOOLS"
echo "================================"

read -p "Pilih menu: " menu

if [ "$menu" == "5" ]; then

echo "Menghapus panel..."

systemctl stop wings 2>/dev/null
pkill wings 2>/dev/null

docker system prune -a -f 2>/dev/null

rm -rf /var/www/pterodactyl
rm -rf /etc/pterodactyl
rm -rf /var/lib/pterodactyl

rm -f /usr/local/bin/wings
rm -f /etc/systemd/system/wings.service

rm -f /etc/nginx/sites-enabled/pterodactyl.conf
rm -f /etc/nginx/sites-available/pterodactyl.conf

systemctl daemon-reload

systemctl restart nginx 2>/dev/null
systemctl restart mysql 2>/dev/null
systemctl restart redis-server 2>/dev/null

echo "UNINSTALL PANEL SELESAI"

fi


if [ "$menu" == "6" ]; then

read -p "Masukkan token wings: " token

echo "Menjalankan wings..."

mkdir -p /etc/pterodactyl

echo "$token" > /etc/pterodactyl/config.yml

curl -L https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64 -o /usr/local/bin/wings

chmod +x /usr/local/bin/wings

cat > /etc/systemd/system/wings.service <<EOF
[Unit]
Description=Pterodactyl Wings
After=docker.service

[Service]
User=root
WorkingDirectory=/etc/pterodactyl
LimitNOFILE=4096
ExecStart=/usr/local/bin/wings
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable wings
systemctl restart wings

echo "WINGS BERHASIL DIJALANKAN"

fi
