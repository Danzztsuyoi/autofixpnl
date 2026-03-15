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

echo "Masukkan API KEY PANEL: "
read apikey


cd /var/www/pterodactyl || { echo "Direktori tidak ditemukan"; exit 1; }

panel=$(grep APP_URL .env | cut -d '=' -f2)

php artisan p:location:make <<EOF
$location_name
$location_description
EOF


php artisan p:node:make <<EOF
$node_name
$location_description
$locid
https
$domain
yes
no
no
$ram
$ram
$disk_space
$disk_space
100
8080
2022
/var/lib/pterodactyl/volumes
EOF


echo "Membuat Allocation 2000-5000..."

curl -X POST "$panel/api/application/nodes/$locid/allocations" \
-H "Authorization: Bearer $apikey" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-d "{
\"ip\": \"0.0.0.0\",
\"ports\": [\"2000-5000\"],
\"alias\": \"$domain\"
}"

echo "Node dan Allocation berhasil dibuat."
