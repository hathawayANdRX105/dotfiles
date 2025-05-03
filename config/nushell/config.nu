# zoxide
source ~/.zoxide.nu

# starship prompt
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# Automatically start zellij
let in_hyprland = ($env | get -i HYPRLAND_INSTANCE_SIGNATURE | is-not-empty)
let is_zellij_start = 'ZELLIJ' not-in ($env | columns)
if $in_hyprland and $is_zellij_start {
  if 'ZELLIJ_AUTO_ATTACH' in ($env | columns) and $env.ZELLIJ_AUTO_ATTACH == 'true' {
    zellij attach -c
  } else {
    zellij
  }
  if 'ZELLIJ_AUTO_EXIT' in ($env | columns) and $env.ZELLIJ_AUTO_EXIT == 'true' {
    exit
  }
}

# alias
alias suhx = sudo hx --config ~/.config/helix/config.toml
alias cat = bat
alias cd = z

# ls
alias l = eza --icons  -a --group-directories-first -1 --long
alias lt = eza --icons --tree --group-directories-first

# move file to 'trash' 
alias rm = rm -t

# job
alias fg = do -i { job unfreeze }

# yazi
alias y = yazi
alias sy = sudo yazi

# wechat
alias wechat = /opt/wechat/wechat
