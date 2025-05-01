#!/usr/bin/env nu

# 生成临时文件（内存存储）
let temp_file = (mktemp -p /dev/shm pin-screenshot-XXXXXX.png)

# 1. 区域截图
let geometry = (slurp -d -c '#BF616A80' -s '#00000000' -b '#2E344080')
grim -g $geometry $temp_file

# 2. 使用 swaybg 显示图像（Hyprland 兼容）
imv $temp_file

# 5. 清理
rm $temp_file
