#!/bin/bash
# Vì file script này nếu chạy ở 1 vị trí khác, thì nó sẽ không thể
# .. import các file khác (ex: function.sh) được, nên cần phải chuyển đến thư mục gốc (bash_location)
bash_location=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$bash_location"

source ../function.sh

echo "Running on $OS - $bash_location"
# Nhập nội dung của file .env ở thư mục gốc
source ../.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

# Lấy version của Elasticsearch
VERSION=$(curl -s --user $CURL_USER -X GET "${HOST}" | jq -r '.version.number')

echo "${green}Elasticsearch version:${reset} ${VERSION}"
