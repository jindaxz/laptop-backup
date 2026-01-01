#!/bin/bash

# 紧急USB监控 - 如果系统异常会自动报警
echo "=== 紧急USB监控启动 ==="

# 记录基线USB设备数量
BASELINE=$(lsusb | wc -l)
echo "基线USB设备数: $BASELINE"

# 开始监控
while true; do
    CURRENT=$(lsusb | wc -l)
    
    if [ $CURRENT -gt $BASELINE ]; then
        echo "⚠️ 检测到新USB设备！"
        echo "新设备信息："
        lsusb | tail -1
        
        # 检查系统响应
        if ! timeout 3 ls /dev/null >/dev/null 2>&1; then
            echo "🚨 系统响应异常！立即拔出USB设备！"
            break
        fi
        
        echo "✅ 系统响应正常"
        sleep 2
    elif [ $CURRENT -lt $BASELINE ]; then
        echo "📤 USB设备已移除"
        BASELINE=$CURRENT
    fi
    
    sleep 1
done