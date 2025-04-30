# source ./log.nu

# def wlog [mes:string] {
#   log $mes --file "/tmp/toggle-wechat.txt"
# }

let focus_window = hyprctl activewindow -j | from json 
let focus_window_class = $focus_window | get initialClass
if $focus_window_class == "wechat" {
  # wlog  "hide wechat"
  # just hide it when current focus window is wechat
  hyprctl dispatch movetoworkspacesilent special:wechat, initialclass:wechat
  exit
}

let wechat_info = hyprctl clients -j | from json | where initialClass == 'wechat'
if ($wechat_info | length) < 1 {
  # wlog "it need to open wechat"
  # can't fint the wechat, need to open
  /opt/wechat/wechat
  exit
}

let wechat_info = $wechat_info | get 0

let wechat_in_special_workspace = ($wechat_info | get workspace.name) == 'special:wechat'

if $wechat_in_special_workspace {
  # wlog  "pop show"
  # pop show wechat when it is in special workspace
  hyprctl dispatch movetoworkspace +0, initialclass:wechat
} else {
  let current_workspace_id = hyprctl activeworkspace -j | from json | get id
  let wechat_workspace_id = $wechat_info | get workspace.id
  if $wechat_workspace_id == $current_workspace_id {
    # wlog  "wechat's the same workspace, and focus it"
    hyprctl dispatch focuswindow initialclass:wechat
  } else {
    # wlog  "move wechat in current workspace."
    hyprctl dispatch movetoworkspace +0, initialclass:wechat
  }
}
