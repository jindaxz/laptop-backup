#!/bin/bash

# 每日增量备份脚本
BACKUP_DIR="/home/osx/Documents/code/backup"
LOG_DIR="$BACKUP_DIR/logs"
DATE=$(date +%Y%m%d)
LOG_FILE="$LOG_DIR/daily_backup_$DATE.log"
LOCK_FILE="$BACKUP_DIR/backup.lock"

mkdir -p "$LOG_DIR"

# 检查是否已有备份在运行
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if kill -0 $PID 2>/dev/null; then
        echo "$(date): 备份已在运行 (PID: $PID)" | tee -a "$LOG_FILE"
        exit 1
    else
        rm -f "$LOCK_FILE"
    fi
fi

# 创建锁文件
echo $$ > "$LOCK_FILE"

echo "$(date): 开始每日增量备份..." | tee -a "$LOG_FILE"

# 增量备份 - 只同步变更的文件
rclone sync "$HOME" gdrive:daily_backup/ \
    --progress \
    --stats 5m \
    --log-file "$LOG_FILE" \
    --log-level INFO \
    --exclude '.cache/**' \
    --exclude '.local/share/Trash/**' \
    --exclude '.thumbnails/**' \
    --exclude '*.tmp' \
    --exclude '*.temp' \
    --exclude '.mozilla/firefox/*/Cache/**' \
    --exclude '.config/google-chrome/Default/Cache/**' \
    --exclude '.config/Code/Cache/**' \
    --exclude '.config/Slack/Cache/**' \
    --exclude 'snap/**' \
    --exclude '.steam/**' \
    --exclude '.wine/**' \
    --exclude 'VirtualBox VMs/**' \
    --exclude '.vagrant.d/**' \
    2>&1

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "$(date): 每日备份完成成功" | tee -a "$LOG_FILE"
else
    echo "$(date): 备份失败，退出码: $EXIT_CODE" | tee -a "$LOG_FILE"
fi

# 清理30天前的日志
find "$LOG_DIR" -name "daily_backup_*.log" -mtime +30 -delete

# 删除锁文件
rm -f "$LOCK_FILE"

exit $EXIT_CODE
