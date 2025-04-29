# 获取当前 TTY 设备名
let current_tty = (tty)

# 判断是否为 tty1 且未运行 Hyprland
if $current_tty == "/dev/tty1" and (ps | where name == "Hyprland" | is-empty) {
    # 启动 Hyprland 并退出 Shell
    exec Hyprland
}
