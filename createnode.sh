#!/bin/bash

clear

echo "Masukkan nama lokasi:"
read location

echo "Masukkan deskripsi lokasi:"
read desc

echo "Masukkan domain:"
read domain

echo "Masukkan nama node:"
read nodename

echo "Masukkan RAM (dalam MB):"
read ram

echo "Masukkan jumlah maksimum disk space (dalam MB):"
read disk

echo "Masukkan Locid:"
read locid

cd /var/www/pterodactyl

php artisan p:location:make <<EOF
$location
$desc
EOF

php artisan p:node:make <<EOF
$nodename
$desc
$locid
https
$domain
yes
no
no
$ram
$ram
$disk
$disk
100
8080
2022
/var/lib/pterodactyl/volumes
EOF

echo "Node berhasil dibuat"
