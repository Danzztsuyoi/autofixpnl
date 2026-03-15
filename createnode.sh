
#!/bin/bash

echo "Masukkan nama lokasi: "
read location_name

echo "Masukkan deskripsi lokasi: "
read location_description

echo "Masukkan domain: "
read domain

echo "Masukkan nama node: "
read node_name

echo "Masukkan RAM (dalam MB): "
read ram

echo "Masukkan jumlah maksimum disk space (dalam MB): "
read disk_space

echo "Masukkan Locid: "
read locid

cd /var/www/pterodactyl || { echo "Direktori tidak ditemukan"; exit 1; }

# Membuat lokasi
php artisan p:location:make <<EOF
$location_name
$location_description
EOF

# Membuat node
php artisan p:node:make <<EOF
$node_name
$node_name
$locid
https
$domain
yes
no
no
$ram
0
$disk_space
0
100
8080
2022
/var/lib/pterodactyl/volumes
EOF

echo "================================"
echo "NODE BERHASIL DIBUAT"
echo "================================"
