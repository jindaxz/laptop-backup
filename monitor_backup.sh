#!/bin/bash

# 监控备份进度的脚本
BACKUP_DIR="/home/osx/Documents/code/backup"
LOG_DIR="$BACKUP_DIR/logs"
PROGRESS_FILE="$BACKUP_DIR/backup_progress.txt"
LOG_FILE_PATTERN="$LOG_DIR/backup_*.log"
DAILY_LOG_PATTERN="$LOG_DIR/daily_backup_*.log"
PID_FILE="$BACKUP_DIR/backup.pid"

echo "====== 备份监控器 ======"

# 检查备份是否在运行
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 $PID 2>/dev/null; then
        echo "✅ 备份正在运行 (PID: $PID)"
    else
        echo "❌ 备份进程已停止"
        rm -f "$PID_FILE"
    fi
else
    echo "❓ 没有活动的备份进程"
fi

echo ""
echo "====== 最新进度 ======"
if [ -f "$PROGRESS_FILE" ]; then
    tail -n 10 "$PROGRESS_FILE"
else
    echo "还没有进度信息"
fi

echo ""
echo "====== 最新日志 ======"
LATEST_LOG=$(ls -t $LOG_FILE_PATTERN $DAILY_LOG_PATTERN 2>/dev/null | head -n 1)
if [ -n "$LATEST_LOG" ]; then
    echo "日志文件: $LATEST_LOG"
    echo "最后10行:"
    tail -n 10 "$LATEST_LOG"
else
    echo "没有找到日志文件"
fi

echo ""
echo "====== 实时监控命令 ======"
echo "监控进度: tail -f $PROGRESS_FILE"
echo "监控日志: tail -f \$(ls -t $LOG_FILE_PATTERN $DAILY_LOG_PATTERN | head -n 1)"
