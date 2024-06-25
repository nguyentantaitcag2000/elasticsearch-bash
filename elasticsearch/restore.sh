#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env
source ../function.sh
HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

# Thư mục chứa các file JSON cần nhập vào Elasticsearch
backup_dir="backup/2024-06-24-21h25m10s" # Thay đổi thành thư mục chứa file JSON đã sao lưu
mapping_dir="$backup_dir/mapping"

# Kiểm tra xem thư mục backup tồn tại và có các file JSON không
if [ ! -d "$backup_dir" ] || ! ls -A "$backup_dir"/*.json >/dev/null 2>&1; then
    echo "Không tìm thấy thư mục backup hoặc không có file JSON để nhập vào Elasticsearch."
    exit 1
fi

# Initialize counters
total_documents=0
successful_documents=0
failed_documents=0

# Loop through JSON files in backup directory
for file in "$backup_dir"/*.json; do
    echo "-----------------------------"
    # Khi backup file thì xuất hiện 1 file index.json, file này không liên quan gì tới các index đang có, nên khi restore lại sẽ tranh
    index=$(basename "$file" .json)

    # Check if the basename is "index"
    if [ "$index" == "index" ]; then
        echo "Skipping index file: $index.json"
        continue # Skip the rest of the loop for this file
    fi
    # Extract index name from file name

    echo "Index: $index"
    # Import mapping for the current index
    mapping_file="$mapping_dir/${index}.json"
    if [ -f "$mapping_file" ]; then
        echo "Importing mapping from file: $mapping_file"
        response=$(curl -s --user "$CURL_USER" -H "Content-Type: application/json" -XPUT "$HOST/$index" --data-binary "@$mapping_file")

        if echo "$response" | jq -e '.acknowledged == true and .shards_acknowledged == true' >/dev/null; then
            echo "${green}Success: Index creation acknowledged.${reset}"
        else
            echo "${red}Error mapping: $(echo $response | jq -r '.error.reason // "Unknown error"')${reset}"
            exit 1
        fi
    else
        echo "${red}Mapping file not found for index: $index. Skipping mapping import.${reset}"
    fi
    # Add a newline (\n) at the end of the JSON file if not already present
    echo "" >>"$file"

    # Perform the import and capture the JSON response
    response=$(curl -s --user "$CURL_USER" -H "Content-Type: application/json" -XPOST "$HOST/$index/_bulk" --data-binary "@$file")

    # Parse the JSON response
    took=$(echo "$response" | jq -r '.took')
    errors=$(echo "$response" | jq -r '.errors')
    items=$(echo "$response" | jq -r '.items')

    # Count successful and failed documents
    successful_count=$(echo "$items" | jq -r '.[] | select(.index.result == "created" or .index.result == "updated") | .index._id' | wc -l)
    failed_count=$(echo "$items" | jq -r '.[] | select(.index.result == "error") | .index._id' | wc -l)
    total_count=$(echo "$items" | jq -r 'length')

    # Accumulate totals
    total_documents=$((total_documents + total_count))
    successful_documents=$((successful_documents + successful_count))
    failed_documents=$((failed_documents + failed_count))

    # Display import summary for the current index
    colorResult=$red
    if [  $successful_count == $total_count ]; then
      colorResult=$green
    fi
    echo "${colorResult}"
    echo "Total documents: $total_count"
    echo "Successful documents: $successful_count"
    echo "Failed documents: $failed_count"
    echo "${reset}"
done

# Overall summary
colorResult=$red
if [ $successful_count == $total_count ] && [ $successful_count > 0 ]; then
  colorResult=$green
fi
echo "-----------------------------"
echo "${colorResult}"
echo "Overall Import Summary"
echo "Total documents imported: $total_documents"
echo "Successful documents: $successful_documents"
echo "Failed documents: $failed_documents"
echo "${reset}"
