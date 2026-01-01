#!/bin/bash

# 全量home目录备份到Google Drive
BACKUP_DIR="/home/osx/Documents/code/backup"
LOG_DIR="$BACKUP_DIR/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/backup_$(date +%Y%m%d_%H%M%S).log"
PROGRESS_FILE="$BACKUP_DIR/backup_progress.txt"
PID_FILE="$BACKUP_DIR/backup.pid"

echo "开始备份整个home目录到Google Drive..." | tee -a "$LOG_FILE"
echo "日志文件: $LOG_FILE"
echo "进度文件: $PROGRESS_FILE"
echo "PID文件: $PID_FILE"

# 记录开始时间
START_TIME=$(date)
echo "开始时间: $START_TIME" | tee -a "$LOG_FILE"

# 开始备份
echo "正在备份 $HOME 到 gdrive:home_backup_full/" | tee -a "$LOG_FILE"

rclone copy "$HOME" gdrive:home_backup_full/ \
    --progress \
    --stats 30s \
    --stats-file-name-length 0 \
    --log-file "$LOG_FILE" \
    --log-level INFO \
    --exclude '.cache/**' \
    --exclude '.local/share/Trash/**' \
    --exclude '.thumbnails/**' \
    --exclude '*.tmp' \
    --exclude '*.temp' \
    --exclude '.mozilla/firefox/*/Cache/**' \
    --exclude '.config/google-chrome/Default/Cache/**' \
    --exclude 'snap/**' \
    --exclude '.steam/**' \
    --exclude '.wine/**' \
    --exclude 'VirtualBox VMs/**' \
    --exclude '.vagrant.d/**' \
    2>&1 | tee -a "$PROGRESS_FILE"

# 记录结束时间
END_TIME=$(date)
echo "结束时间: $END_TIME" | tee -a "$LOG_FILE"
echo "备份完成！" | tee -a "$LOG_FILE"

# 显示备份统计
echo "备份统计:" | tee -a "$LOG_FILE"
rclone size gdrive:home_backup_full/ | tee -a "$LOG_FILE"

# 清理PID文件
rm -f "$PID_FILE"
