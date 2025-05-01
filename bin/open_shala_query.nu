# idk why hyprland cannot set floorp window floating in window rule.
# The solution here is use the cmd to make the window floating.
let browser = "zen"
let is_in_browser = hyprctl activewindow -j | from json | get class | str contains $browser

if $is_in_browser {
  # hyprland will not comsume the shortkey, floorp will open the window.
  # hyprctl dispatch sendshortcut ALT, Q, class:floorp;

  let exit_time = 5;
  let time_unit = 0.5;
  mut escaped_time = 0.0; 
  mut is_ok = false;
  while not $is_ok and $escaped_time <= $exit_time {
    nu -c $"sleep ($time_unit)sec";
    
    let is_opened = hyprctl clients -j | from json | select class title | where class == $browser | any {|e| $e.title | str contains "沙拉"};
    $is_ok = $is_ok or $is_opened; 
    $escaped_time += $time_unit;
  }

  if $is_ok {
    do -i {
      hyprctl --batch "dispatch setfloating title:.*沙拉.*; dispatch centerwindow; dispatch focuswindow title:.*沙拉.*;";
    }
  }
}
