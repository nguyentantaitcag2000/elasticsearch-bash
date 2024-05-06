#!/bin/bash

set -e
# Change working directory to the directory of this script
cd "$(dirname "$0")"
# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"
echo -n "Enter INDEX name to create: "
read INDEX
curl -s --user $CURL_USER -X GET "${HOST}/${INDEX}/_shard_stores"

curl -s --user $CURL_USER -X GET "${HOST}/_cluster/settings"

curl -s --user $CURL_USER -X PUT "${HOST}/_cluster/settings" -H 'Content-Type: application/json' -d '{
  "persistent": {
    "cluster.routing.allocation.enable": "all"
  }
}'
