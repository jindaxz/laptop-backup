#!/bin/bash

# 备份服务管理脚本
BACKUP_DIR="/home/osx/Documents/code/backup"
SERVICE_NAME="daily-backup"

install_service() {
    echo "安装每日备份服务..."
    
    # 创建systemd用户服务
    mkdir -p ~/.config/systemd/user
    
    cat > ~/.config/systemd/user/daily-backup.service << EOF
[Unit]
Description=Daily Home Backup to Google Drive
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=$BACKUP_DIR/daily_backup.sh
Environment=HOME=$HOME
Environment=PATH=/usr/local/bin:/usr/bin:/bin
WorkingDirectory=$BACKUP_DIR

[Install]
WantedBy=default.target
EOF

    # 创建定时器
    cat > ~/.config/systemd/user/daily-backup.timer << EOF
[Unit]
Description=Run backup once after boot and every 24h
Requires=daily-backup.service

[Timer]
OnBootSec=5min
OnUnitActiveSec=1d
Persistent=true

[Install]
WantedBy=timers.target
EOF

    # 重新加载并启用服务
    systemctl --user daemon-reload
    systemctl --user enable daily-backup.timer
    systemctl --user start daily-backup.timer
    
    # 启用用户级别的lingering（重启后自动启动）
    sudo loginctl enable-linger $USER
    
    echo "✅ 服务安装完成"
    echo "✅ 开机后5分钟自动备份"
    echo "✅ 重启后自动运行"
}

uninstall_service() {
    echo "卸载每日备份服务..."
    systemctl --user stop daily-backup.timer 2>/dev/null
    systemctl --user disable daily-backup.timer 2>/dev/null
    rm -f ~/.config/systemd/user/daily-backup.service
    rm -f ~/.config/systemd/user/daily-backup.timer
    systemctl --user daemon-reload
    
    # 移除cron任务
    crontab -l 2>/dev/null | grep -v daily_backup.sh | crontab -
    
    echo "✅ 服务卸载完成"
}

status_service() {
    echo "====== 服务状态 ======"
    systemctl --user status daily-backup.timer --no-pager
    echo ""
    echo "====== 下次运行时间 ======"
    systemctl --user list-timers daily-backup.timer --no-pager
    echo ""
    echo "====== 最近日志 ======"
    journalctl --user -u daily-backup.service --no-pager -n 10
}

case "$1" in
    install)
        install_service
        ;;
    uninstall)
        uninstall_service
        ;;
    status)
        status_service
        ;;
    *)
        echo "用法: $0 {install|uninstall|status}"
        echo ""
        echo "install   - 安装每日备份服务（重启后自动运行）"
        echo "uninstall - 卸载服务"
        echo "status    - 查看服务状态"
        exit 1
        ;;
esac
