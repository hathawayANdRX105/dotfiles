#!/usr/bin/env nu
# source ./log.nu

# def wlog [mes:string] {
#   log $mes --file "/tmp/toggle-wechat.txt"
# }
def main [] {
  let wechat_info = hyprctl clients -j | from json | where initialClass == 'wechat'
  if ($wechat_info | length) < 1 {
    # wlog "it need to open wechat"
    # can't fint the wechat, need to open
    /opt/wechat/wechat
    return
  }

  let focus_window = hyprctl activewindow -j | from json 
  let focus_window_class = $focus_window | get initialClass
  if $focus_window_class == "wechat" {
    # wlog  "hide wechat"
    # just hide it when current focus window is wechat
    hyprctl dispatch movetoworkspacesilent special:wechat, initialclass:wechat
    return
  }

  let wechat_info = $wechat_info | get 0
  let wechat_in_special_workspace = ($wechat_info | get workspace.name) == 'special:wechat'
  if $wechat_in_special_workspace {
    # wlog  "pop show"
    # pop show wechat when it is in special workspace
    hyprctl --batch "dispatch movetoworkspace +0, initialclass:wechat; dispatch alterzorder top, initialclass:wechat; dispatch focuswindow initialclass:wechat; dispatch resizeactive exact 1100 900;"
  } else {
    let current_workspace_id = hyprctl activeworkspace -j | from json | get id
    let wechat_workspace_id = $wechat_info | get workspace.id
    if $wechat_workspace_id == $current_workspace_id {
      # wlog  "wechat's the same workspace, and focus it"
      hyprctl dispatch focuswindow initialclass:wechat
      hyprctl dispatch alterzorder top, initialclass:wechat  
    } else {
      # wlog  "move wechat in current workspace."
      hyprctl dispatch movetoworkspace +0, initialclass:wechat
      hyprctl dispatch alterzorder top, initialclass:wechat  
    }
  }
}
