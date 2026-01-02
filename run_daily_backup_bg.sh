#!/bin/bash

# Wrapper to launch daily_backup.sh in the background with nohup.
BACKUP_DIR="/home/osx/Documents/code/backup"
LOG_DIR="$BACKUP_DIR/logs"
SCRIPT="$BACKUP_DIR/daily_backup.sh"

mkdir -p "$LOG_DIR"

if [ ! -x "$SCRIPT" ]; then
    echo "找不到可执行的 daily_backup.sh: $SCRIPT"
    exit 1
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
NOHUP_LOG="$LOG_DIR/manual_nohup_$TIMESTAMP.log"

echo "使用 nohup 启动每日备份..."
nohup "$SCRIPT" >> "$NOHUP_LOG" 2>&1 &
PID=$!
echo "$PID" > "$BACKUP_DIR/backup.pid"
echo "✅ 已在后台启动 (PID: $PID)"
echo "日志: $NOHUP_LOG"
