#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

# Hỏi tên index
echo -n "Enter repository name: "
read RES_NAME


# Thực hiện cURL để lấy document
curl --user $CURL_USER "$HOST/_snapshot/$RES_NAME" -H "Content-Type: application/json" -d '{
  "type": "fs",
  "settings": {
    "location": "backup-es"
  }
}' | jq .

# Tạo snapshot cho Elasticsearch
snapshot_name="snapshot_$(date +%F.%H%M%S)"
curl --user $CURL_USER "$HOST/_snapshot/$RES_NAME/$snapshot_name" -H "Content-Type: application/json" -d '{
   "indices": "_all",
   "ignore_unavailable": true,
   "include_global_state": false
}' | jq .
