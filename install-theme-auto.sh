#!/bin/bash

echo "================================"
echo "AUTO INSTALL THEME PTERODACTYL"
echo "================================"

THEME=$1

cd /var/www/pterodactyl || exit

if [[ "$THEME" == b* ]]; then

echo "CEK BLUEPRINT..."

if [ ! -f "blueprint.sh" ]; then
echo "INSTALL BLUEPRINT..."

apt update -y
apt install -y curl wget unzip nodejs npm

npm i -g yarn

wget -q https://github.com/BlueprintFramework/framework/releases/latest/download/release.zip -O blueprint.zip

unzip -o blueprint.zip
rm blueprint.zip

chmod +x blueprint.sh

yes | bash blueprint.sh

echo "Blueprint berhasil diinstall"
else
echo "Blueprint sudah ada"
fi

fi


echo "INSTALL THEME $THEME..."

printf "rendzzoffc\n1\n$THEME\ny\n" | bash <(curl -s https://raw.githubusercontent.com/RendzzXs/Installtheme/main/install.sh)

echo "================================"
echo "INSTALL SELESAI"
echo "================================"
