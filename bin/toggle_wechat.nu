# TODO: Poping up wechat if it don't show up in any workspace.
let wechat_in_special_workspace = hyprctl clients -j | from json | select workspace.name initialClass | where 'workspace.name' == 'special:wechat' and initialClass == 'wechat' | length | $in > 0;

if $wechat_in_special_workspace {
  do -i {
    # This dispatch only contains one window rule, and the rule name should be lowercase.
    hyprctl dispatch movetoworkspace +0, initialclass:wechat;
  }
} else {
  do -i {
    hyprctl dispatch movetoworkspacesilent special:wechat, initialclass:wechat;
  }
}
