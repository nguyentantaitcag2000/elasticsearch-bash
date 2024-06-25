#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ../../function.sh
SCRIPT_DIR=$(get_document_root)
source "$SCRIPT_DIR/.env"

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"
# ANSI color codes
RED='\033[0;31m'
NC='\033[0m' # No Color

# Hỏi tên index
echo -n "Enter new INDEX name: "
read INDEX
# Thay thế tất cả dấu gạch dưới bằng dấu gạch ngang
FILE_NAME_FULL="${INDEX//_/-}" # example: quiz_qa => quiz-qa
make_valid_file_path(){
    local FILE_NAME="$1"
    # Kiểm tra nếu FILE_NAME không chứa ".json" thì thêm vào
    if [[ ! "$FILE_NAME" == *".json" ]]; then
        # Xóa phần _<số> hoặc -<số> cuối cùng nếu có -  ví dụ nó có thể có dạng personal_post_1, personal_post_49
        FILE_NAME="${FILE_NAME%_[0-9]*}"
        FILE_NAME="${FILE_NAME%-[0-9]*}"
        # echo "xx > $FILE_NAME"
        FILE_NAME="${FILE_NAME}.json"
    fi
    FILE_NAME_FULL="./config/${FILE_NAME}"
    echo "$FILE_NAME_FULL"
}
FILE_NAME_FULL=$(make_valid_file_path "$FILE_NAME_FULL")
# Kiểm tra xem file có tồn tại không
if [ ! -f "$FILE_NAME_FULL" ]; then
    echo -e "${RED}${FILE_NAME_FULL} - File not found!${NC}"
    msgEnterFileName="Enter mapping file name (example: personal-post.json): "
    while true; do

        # Hỏi tên file mapping
        echo -n "$msgEnterFileName"
        read FILE_NAME
        FILE_NAME_FULL=$(make_valid_file_path "$FILE_NAME")

        # Kiểm tra xem file có tồn tại không
        if [[ "$FILE_NAME" == "x" ]]; then
            exit 1
        elif [ ! -f "$FILE_NAME_FULL" ]; then
            echo -e "${RED}${FILE_NAME_FULL} - File not found!${NC}"
            msgEnterFileName="Enter mapping file name again (Press 'x' to exit): "
        else
            break
        fi
    done
fi

# Sử dụng nội dung của tệp đó trong lệnh curl
curl --user $CURL_USER -X PUT "$HOST/$INDEX" -H 'Content-Type: application/json' --data-binary "@$FILE_NAME_FULL" | jq .