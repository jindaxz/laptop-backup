#!/bin/bash

# 检查备份状态脚本
BACKUP_DIR="/home/osx/Documents/code/backup"
LOG_DIR="$BACKUP_DIR/logs"

echo "====== 每日备份状态 ======"

# 检查今天的备份日志
TODAY=$(date +%Y%m%d)
TODAY_LOG="$LOG_DIR/daily_backup_$TODAY.log"

if [ -f "$TODAY_LOG" ]; then
    echo "✅ 今天的备份日志存在: $TODAY_LOG"
    echo "最后10行:"
    tail -n 10 "$TODAY_LOG"
else
    echo "❓ 今天还没有备份日志"
fi

echo ""
echo "====== 最近的备份日志 ======"
ls -lt $LOG_DIR/daily_backup_*.log 2>/dev/null | head -5

echo ""
echo "====== Cron任务状态 ======"
crontab -l | grep daily_backup

echo ""
echo "====== 锁文件检查 ======"
if [ -f "$BACKUP_DIR/backup.lock" ]; then
    PID=$(cat "$BACKUP_DIR/backup.lock")
    if kill -0 $PID 2>/dev/null; then
        echo "⚠️  备份正在运行 (PID: $PID)"
    else
        echo "🗑️  发现死锁文件，建议删除"
        rm -f "$BACKUP_DIR/backup.lock"
        echo "✅ 锁文件已清理"
    fi
else
    echo "✅ 没有锁文件，状态正常"
fi

echo ""
echo "====== Google Drive空间 ======"
rclone about gdrive: 2>/dev/null || echo "❌ 无法连接Google Drive"
