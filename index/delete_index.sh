#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

HOST="${SERVER_ES}"
CURL_USER="${USERNAME_ES}:${PASSWORD_ES}"

echo -n "Enter INDEX name: "
read INDEX

read -p "Are you sure? (y/n) " answer
case $answer in
    [Yy]* ) 
        # Đặt lệnh bạn muốn thực hiện khi người dùng trả lời 'y' hoặc 'Y' ở đây
        echo "Đang thực hiện lệnh..."
	    curl --user $CURL_USER -XDELETE "$HOST/$INDEX?pretty"
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