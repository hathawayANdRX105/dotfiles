#!/usr/bin/env nu
# source ~/dotfiles/bin/log.nu

def main [buffer_name: path] {
  if ($env.YAZI_ID | is-empty) {
    print "Error: YAZI_ID not set. reveal-in-yazi requires that you open helix from yazelix's yazi."
    return
  }

  if ($buffer_name | is-empty) {
    print "Error: Buffer name not provided"
    return
  }
  let normalized_buffer_name = if ($buffer_name | str contains "~") {
      $buffer_name | path expand
  } else {
      $buffer_name
  }
  
  let full_path = ($env.PWD | path join $normalized_buffer_name | path expand)
  if not ($full_path | path exists) {
    print $"the full path doesn't exist:($full_path)"
    # log $"the full path doesn't exist:($full_path)" --file "/tmp/helix.log"
    return 
  }
  # log $"($buffer_name) ($env.PWD) ($full_path)" --file "/tmp/helix.log"

  let dir = ($full_path | path dirname)
  ya emit-to $env.YAZI_ID cd $dir | complete 
  zellij action move-focus left
}
