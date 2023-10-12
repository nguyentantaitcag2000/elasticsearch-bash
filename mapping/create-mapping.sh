#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"


# Hỏi tên index
echo -n "Enter new INDEX name: "
read INDEX

curl --user $CURL_USER -X PUT "$HOST/$INDEX" -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "dynamic_templates": [
      {
        "strings_as_text": {
          "match_mapping_type": "string",
          "mapping": {
            "type": "text"
          }
        }
      }
    ],
    "properties": {
      "uptime_post": {
        "type": "date",
        "format": "yyyy-MM-dd HH:mm:ss"
      },
      "regtime_post": {
        "type": "date",
        "format": "yyyy-MM-dd HH:mm:ss"
      },
      "id_post_status": {
        "type": "integer"
      },
      "id_user": {
        "type": "long"
      },
      "username": {
        "type": "keyword"
      },
      "content_post": {
        "type": "text",
        "index": false
      }
    }
  }
}' | jq .
