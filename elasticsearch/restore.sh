#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

# Thư mục chứa các file JSON cần nhập vào Elasticsearch
backup_dir="backup/2024-06-23-220925"  # Thay đổi thành thư mục chứa file JSON đã sao lưu

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
    continue  # Skip the rest of the loop for this file
  fi
  # Extract index name from file name
  
  echo "Importing data from file: $file to index: $index"
  
  # Add a newline (\n) at the end of the JSON file if not already present
  echo "" >> "$file"
  
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
  echo "Index: $index"
  echo "Total documents: $total_count"
  echo "Successful documents: $successful_count"
  echo "Failed documents: $failed_count"
done

# Overall summary
echo "-----------------------------"
echo "Overall Import Summary"
echo "Total documents imported: $total_documents"
echo "Successful documents: $successful_documents"
echo "Failed documents: $failed_documents"