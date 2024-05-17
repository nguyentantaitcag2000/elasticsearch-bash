#!/bin/bash
set -e
# Kiểm tra xem biến đã được truyền vào hay chưa
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <index>"
    exit 1
fi
INDEX=$1
./mapping_index.sh $INDEX
curl --user $CURL_USER -H "Content-Type: application/x-ndjson" -XPOST "http://localhost:9200/$INDEX/_bulk" --data-binary @../data.json
