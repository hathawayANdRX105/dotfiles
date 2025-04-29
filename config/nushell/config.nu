# zoxide
source ~/.zoxide.nu

# starship prompt
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")


# alias
alias suhx = sudo hx --config ~/.config/helix/config.toml
alias cat = bat
alias cd = z

# ls
alias l = eza --icons  -a --group-directories-first -1
alias ll = eza --icons  -a --group-directories-first -1 --no-user --long
alias lt = eza --icons --tree --group-directories-first

# move file to 'trash' 
alias rm = rm -t

# job
alias fg = do -i { job unfreeze }
