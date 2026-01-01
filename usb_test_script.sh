#!/bin/bash

# 安全的USB测试脚本
echo "=== USB安全测试脚本 ==="

echo "1. 检查USB控制器状态："
lspci | grep -i usb

echo "2. 检查USB模块："
lsmod | grep -E "xhci|ehci|ohci" | head -5

echo "3. 当前USB设备（内置）："
lsusb

echo "4. USB设备监控（30秒）："
echo "请在30秒内插入USB设备进行测试..."

timeout 30 bash -c '
    while true; do
        NEW_DEVICES=$(lsusb | wc -l)
        if [ $NEW_DEVICES -gt 6 ]; then
            echo "检测到新USB设备！"
            lsusb | tail -1
            break
        fi
        sleep 1
    done
'

echo "测试完成。"