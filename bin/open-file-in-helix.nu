#!/usr/bin/env nu
# Open default editor to edit file using by yazi.

def is_x_running [program: string] {
  # zellij action list-clients can get some info.
  # demo: /etc/profiles/per-user/hathaway/bin/hx --config /home/hathaway/.nixos-config/home/config/helix/config.toml
  let running_command = zellij action list-clients | lines | get 1 | parse -r '\w+\s+\w+\s+(?<RUNNING_COMMAND>.*)' | get RUNNING_COMMAND | to text

  let cwd = $running_command | str trim | str downcase | split row ' ' | get 0

  let has_x = $cwd | str ends-with $"/($program)"
  let is_x = $cwd == $program
  $has_x or $is_x
}

# Use the 'zellij action write' command to stimulate the keyboard movement.
# Find BYTES represent meaning in ascii code. 
# escape(27) enter(13)
def escape_to_normal_mode [] {
  zellij action write 27
}

# Use the 'zellij action write' command to stimulate the keyboard movement.
# Find BYTES represent meaning in ascii code. 
# escape(27) enter(13)
def execute [cmd: string] {
  zellij action write-chars $cmd
  zellij action write 13
}

def open_file_in_exsiting_helix [file_path: path] {
  if not ($file_path | path exists) {
    print $"Error: File path ($file_path) does not exist."
    return
  }

  let working_dir = if ($file_path | path type) == "dir" {
      $file_path
  } else {
      $file_path | path dirname
  }

  try {
    
    # 1. escape the input mode or just nothing to happen
    escape_to_normal_mode

    # 2. cd the work directory in command mode
    execute $":cd ($working_dir)"

    # 3. open/edit the specific file in command mode
    execute $":open ($file_path)"

    # 4. rename the zellij tab
    zellij action rename-pane "editor"
  } catch {|err|
    print $"Error executing commands: ($err.msg)"
  }
}

# create a new pane in zellij and edit that file with helix
def open_file_in_new_helix_pane [file_path: path, yazi_id: string] {
  if not ($file_path | path exists) {
    print $"Error: File path ($file_path) does not exist."
    return
  }

  let working_dir = if ($file_path | path type) == "dir" {
      $file_path
  } else {
      $file_path | path dirname
  }

  try {
    # 1. open new pane and edit that file with helix.
    let cmd = $"env YAZI_ID=($yazi_id) hx ($file_path)"
    zellij run --name "helix" --cwd $working_dir -- nu -c $cmd 

    # 2. rename pane
    zellij action rename-pane "editor"
  } catch {|err|
    print $"Error executing commands: ($err.msg)"
  }
}

# TODO: change to use zellij plugin to focus the pane of helix
def focus_helix [] {
    zellij action move-focus right
    zellij action move-focus up
    zellij action move-focus up
    zellij action move-focus up
    zellij action move-focus up
    zellij action move-focus up
}

def main [file_path: path] {
  # if zellij is never opened, just use helix to edit
  let is_zellij_start = 'ZELLIJ' in ($env | columns)
  if not $is_zellij_start {
    hx $file_path
    return
  }

  if not ($file_path | path exists) {
    print $"Error: File path ($file_path) does not exist"
    return
  }

  let yazi_id = $env.YAZI_ID
  if ($yazi_id | is-empty) {
    print "Warning: YAZI_ID not set in this environment. Yazi navigation may fail."
  }

  focus_helix
  if (is_x_running "hx") {
    open_file_in_exsiting_helix $file_path
  } else {
    open_file_in_new_helix_pane $file_path $yazi_id
  }
}
