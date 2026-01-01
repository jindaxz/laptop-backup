# BIOS/UEFI USB设置检查清单

## 进入BIOS
- 重启后按 F2 或 Delete（联想通常是F2）
- 部分机型可能是 F1 或 Fn+F2

## 关键设置位置
1. **Advanced** → **USB Configuration**
2. **Peripherals** → **USB Settings**
3. **I/O Ports** → **USB Ports**

## 必检项目
### USB控制器
- [ ] USB Controller: **Enabled**
- [ ] USB 2.0 Controller: **Enabled** 
- [ ] USB 3.0 Controller: **Enabled** (问题时可临时Disabled)
- [ ] XHCI Hand-off: **Enabled**
- [ ] Legacy USB Support: **Enabled**

### 电源管理（重要！）
- [ ] USB Wake Up: **Disabled** ⚠️
- [ ] USB Charge in S4/S5: **Disabled** ⚠️  
- [ ] USB Power Share: **Disabled** ⚠️

### 联想特有设置
- [ ] Always On USB: **Disabled**
- [ ] USB Ports: **All Enabled**
- [ ] USB Mass Storage: **Enabled**

## 重置方案
1. **保守方案**: 只禁用USB 3.0，测试USB 2.0
2. **完全重置**: Load Setup Defaults
3. **紧急恢复**: Load Optimized Defaults

## 操作步骤
1. 用手机拍照记录当前设置
2. 尝试修改设置
3. F10保存退出
4. 测试USB功能
5. 如有问题立即回滚