let wechat_ids = (xdotool search --class "wechat" | lines)
if ($wechat_ids | is-empty) {
    echo "wechat didnot open"
    /opt/wechat/wechat
    exit
}

# when wechat exists
# wechat is hidden in desktop => id0
# wechat is showing up in desktop => id1
let id0 = ($wechat_ids | first)
let id1 = ($wechat_ids | last)
let wechat_id = if ($id0 | str length) > ($id1 | str length) {
    $id1
} else {
    $id0
}
let current_id = (xdotool getwindowfocus)

if ($wechat_id == $current_id) {
    # wechat was focused, then minimize it.
    xdotool windowminimize $wechat_id
} else {
    # wechat need to be focused
    xdotool windowactivate $wechat_id
    xdotool windowraise $wechat_id
}
