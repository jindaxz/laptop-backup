#!/bin/bash

echo "开始备份到Google Drive..."

# 备份重要文件夹
rclone copy /home/osx/Documents gdrive:laptop_backup/Documents -P
rclone copy /home/osx/Pictures gdrive:laptop_backup/Pictures -P
rclone copy /home/osx/Downloads gdrive:laptop_backup/Downloads -P

echo "备份完成！"
echo "查看备份: https://drive.google.com/drive/u/1/my-drive"