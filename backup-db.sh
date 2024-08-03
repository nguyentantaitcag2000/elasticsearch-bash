#!/bin/bash

# Nhập nội dung của file .env ở thư mục gốc
source ~/bash/.env

MY_PASS="${PASS_GPG}"
USERNAME_DB="${DB_USERNAME}"
PASSWORD_DB="${DB_PASSWORD}"

backup_file=/home/website/backup/backup_$(date +%F.%H%M%S).sql.gz
# mysqldump will backup by default all the triggers but NOT the stored procedures/functions. There are 2 mysqldump parameters that control this behavior:
# --routines – FALSE by default
# --triggers – TRUE by default
# Source: https://stackoverflow.com/a/5075216
/usr/bin/mysqldump -u"$USERNAME_DB" -p"$PASSWORD_DB" lazycodet --routines | gzip > $backup_file
/usr/bin/echo "$MY_PASS" | /usr/bin/gpg --batch --passphrase-fd 0 -c $backup_file
#rm $backup_file
/usr/bin/php /home/website/cron/upload-to-telegram.php $backup_file |& tee /home/website/cron/error.log 2>&1
rm $backup_file.gpg
