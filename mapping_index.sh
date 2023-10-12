#!/bin/bash
# Kiểm tra xem biến đã được truyền vào hay chưa
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <index>"
    exit 1
fi
INDEX=$1

curl --user $CURL_USER -X PUT "http://localhost:9200/$INDEX" -H 'Content-Type: application/json' -d'
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
      "content_post": {
        "type": "text",
        "index": false
      }
    }
  }
}'
