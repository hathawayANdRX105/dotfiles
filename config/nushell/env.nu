# disable welcome message of nushell
$env.config.show_banner = false

# editor
$env.EDITOR      = "helix"
$env.SUDO_EDITOR = "helix"
$env.config.buffer_editor = "helix"

# zoxide
zoxide init nushell | save -f ~/.zoxide.nu
