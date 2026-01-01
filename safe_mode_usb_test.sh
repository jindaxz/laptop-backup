#!/bin/bash

# Safe Mode USB测试脚本
echo "=== Safe Mode USB测试 ==="
echo "当前内核: $(uname -r)"
echo "运行级别: $(runlevel)"
echo

# 基础USB检查
echo "1. USB控制器状态："
lspci | grep -i usb
echo

echo "2. 当前USB设备："
lsusb
echo

echo "3. USB内核模块："
lsmod | grep -E "xhci|ehci|ohci"
echo

echo "请插入USB设备进行测试..."
echo "按任意键继续..."
read -n 1

echo
echo "4. 检查新USB设备："
lsusb
echo

echo "5. 检查dmesg日志（最后10行）："
dmesg | tail -10

echo
echo "测试完成！"