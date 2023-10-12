
#!/bin/bash
# Kiểm tra xem biến đã được truyền vào hay chưa
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <index>"
    exit 1
fi
INDEX=$1
curl --user $CURL_USER -X GET "http://localhost:9200/$INDEX/_mapping" | ~/jq ".$INDEX.mappings.properties | with_entries(select(.value.type != \"text\"))"