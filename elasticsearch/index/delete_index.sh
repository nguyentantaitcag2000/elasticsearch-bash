#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

echo -n "Enter INDEX name(s) (separate multiple indices with commas): "
read INDEX
read -p "Are you sure? (y/n) " answer
case $answer in
    [Yy]* )
        # Tách các index ra nếu có dấu ","
        IFS=',' read -ra INDICES <<< "$INDEX"
        for i in "${INDICES[@]}"; do
            i=$(echo $i | xargs)  # Loại bỏ khoảng trắng dư thừa nếu có
            bash _delete_index.sh "$i"
        done
        ;;
    [Nn]* )
        # Thoát script nếu người dùng trả lời 'n' hoặc 'N'
        echo "Thoát!"
        exit
        ;;
    * ) 
        echo "Vui lòng trả lời y hoặc n."
        ;;
esac
