#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env
source ../function.sh
HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"
RESTORE_ES_PATH="${RESTORE_ES_PATH}"

# Thư mục chứa các file JSON cần nhập vào Elasticsearch
echo -n "Enter backup file path: "
read backup_zip
# Extract the base name of the zip file (without path and extension)
backup_file_name=$(basename "$backup_zip")

# Define the temp directory to extract the contents
temp_dir="./temp/$backup_file_name"

# Create temp directory if it doesn't exist
mkdir -p "$temp_dir"

# Check if the backup file exists
if [ -f "$backup_zip" ]; then
    # Extract the zip file into the temp directory
    unzip "$backup_zip" -d "$temp_dir"
    
    # If extraction succeeds
    if [ $? -eq 0 ]; then
        echo "Backup file extracted to $temp_dir"
    else
        echo "Failed to extract the backup file."
        exit 1
    fi
else
    echo "Backup file $backup_zip not found!"
    exit 1
fi

# Continue with your existing logic using temp_dir
mapping_dir="$temp_dir/mapping"
alias_dir="$temp_dir/alias"
echo "mapping_dir: ${mapping_dir}"
# Initialize counters
total_documents=0
successful_documents=0
failed_documents=0

# Loop through JSON files in backup directory
for file in "$temp_dir"/*.json; do
    echo "-----------------------------"
    # Khi backup file thì xuất hiện 1 file index.json, file này không liên quan gì tới các index đang có, nên khi restore lại sẽ tranh
    index=$(basename "$file" .json)
    echo "index: ${index}"
    # Check if the basename is "index"
    if [ "$index" == "index" ] || [ "$index" == "*" ]; then
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

# Loop through alias files in alias directory
if [ -d "$alias_dir" ]; then
    for alias_file in "$alias_dir"/*.json; do
        index=$(basename "$alias_file" .json)
        echo "Importing alias for index: $index from file: $alias_file"

        # Import alias using the bulk alias API
        response=$(curl -s --user "$CURL_USER" -H "Content-Type: application/json" -XPOST "$HOST/_aliases" --data-binary "@$alias_file")

        if echo "$response" | jq -e '.acknowledged == true' >/dev/null; then
            echo "${green}Success: Alias creation acknowledged for index $index.${reset}"
        else
            echo "${red}Error alias: $(echo $response | jq -r '.error.reason // "Unknown error"')${reset}"
        fi
    done
else
    echo "No alias directory found. Skipping alias import."
fi

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

