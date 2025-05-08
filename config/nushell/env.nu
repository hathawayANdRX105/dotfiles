# disable welcome message of nushell
$env.config.show_banner = false

# # executive bin directory
$env.PATH = ($env.PATH | append "~/.local/bin")

$env.http_proxy = "http://127.0.0.1:2081"
$env.https_proxy = "http://127.0.0.1:2081"

# editor
$env.EDITOR      = "hx"
$env.SUDO_EDITOR = "hx"
$env.config.buffer_editor = "hx"

# zoxide
zoxide init nushell | save -f ~/.zoxide.nu

# wayland
$env.MOZ_ENABLE_WAYLAND = "1"

# fcitx5
$env.QT_IM_MODULE = "fcitx"
$env.XMODIFIERS = "@im=fcitx"
# $env.GTK_IM_MODULE = "fcitx" # don't use this for gtk

# xdg
$env.XDG_DESKTOP_DIR     = $"($env.HOME)/Desktop"
$env.XDG_DOCUMENTS_DIR   = $"($env.HOME)/Documents"
$env.XDG_DOWNLOAD_DIR    = $"($env.HOME)/Downloads"
$env.XDG_MUSIC_DIR       = $"($env.HOME)/Music"
$env.XDG_PICTURES_DIR    = $"($env.HOME)/Pictures"
$env.XDG_PUBLICSHARE_DIR = $"($env.HOME)/Public"
$env.XDG_TEMPLATES_DIR   = $"($env.HOME)/Templates"
$env.XDG_VIDEOS_DIR      = $"($env.HOME)/Videos"
$env.XDG_SESSION_TYPE    = "wayland"
$env.XDG_CURRENT_DESKTOP = "Hyprland"
