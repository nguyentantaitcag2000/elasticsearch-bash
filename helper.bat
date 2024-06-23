@echo off
sh helper.sh
REM Nếu như câu lệnh trên lỗi, thì sẽ chạy lênh "helper.sh", thường thì nếu như có cài Git Bash, nó sẽ chạy ở Git Bash
IF ERRORLEVEL 1 (
    echo "The sh command failed. Running helper.sh directly."
    bash helper.sh
)
