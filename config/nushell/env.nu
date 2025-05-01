# disable welcome message of nushell
$env.config.show_banner = false

# editor
$env.EDITOR      = "helix"
$env.SUDO_EDITOR = "helix"
$env.config.buffer_editor = "helix"

# zoxide
zoxide init nushell | save -f ~/.zoxide.nu

# wayland
$env.MOZ_ENABLE_WAYLAND = "1"

# fcitx5
$env.QT_IM_MODULE = "fcitx"
$env.XMODIFIERS = "@im=fcitx"

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
