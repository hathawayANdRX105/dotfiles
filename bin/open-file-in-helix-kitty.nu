#!/usr/bin/env nu
# Open default editor to edit file using by yazi.

# debug
source ./log.nu
def wlog [mes:string] {
  log $mes --file "/tmp/yazi.log"
}

def is_editor_running [] {
  # zellij action list-clients can get some info.
  # demo: /etc/profiles/per-user/hathaway/bin/hx --config /home/hathaway/.nixos-config/home/config/helix/config.toml
  let result = kitty @ ls --match 'title:EDITOR' | complete
  # wlog $"result => ($result.stdout)"
  if $result.exit_code == 1 {
    wlog "Can't find the editor window."
    return false;
  }

  let editor_info = $result.stdout | from json | get tabs | get 0 | get windows | get 0 
  # wlog $"info => ($editor_info)"
  let cmdline = $editor_info | get cmdline | get 0
  # wlog $"cmdline => ($cmdline)"

  let has_hx = $cmdline | str ends-with $"/hx" | get 0
  let is_hx = $cmdline == "hx"
  # wlog $"has_hx => ($has_hx)"
  # wlog $"is_hx => ($is_hx)"
  # wlog $"is editor running => ($has_hx or $is_hx)"
  $has_hx or $is_hx
}

def escape_to_normal_mode [] {
  kitty @ send-key --match 'title:EDITOR' escape
}

def execute [cmd: string] {
  kitty @ send-text --match 'title:EDITOR' $cmd
  kitty @ send-key --match 'title:EDITOR' enter
}

def open_file_in_existing_helix [file_path: path] {
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
    wlog "Open file in existing helix."
    # 1. escape the input mode or just nothing to happen
    escape_to_normal_mode

    # 2. cd the work directory in command mode
    execute $":cd ($working_dir)"

    # 3. open/edit the specific file in command mode
    execute $":open ($file_path)"
  } catch {|err|
    print $"Error executing commands: ($err.msg)"
  }
}

# create a new pane in zellij and edit that file with helix
def open_file_in_new_helix_window [file_path: path, yazi_id: string, tab_id: int] {
  let working_dir = if ($file_path | path type) == "dir" {
      $file_path
  } else {
      $file_path | path dirname
  }

  try {
    # wlog "Open file in new helix."
    kitty @ launch --match $'id:($tab_id)' --title 'EDITOR' --cwd $working_dir --env $'YAZI_ID=($yazi_id)' hx $file_path
  } catch {|err|
    print $"Error executing commands: ($err.msg)"
  }
}

def focus_helix [] {
  # wlog "Focus helix."
  kitty @ focus-window --match 'title:EDITOR'
}

# def main [] {
def main [file_path: path] {
  if not ($file_path | path exists) {
    print $"Error: File path ($file_path) does not exist"
    return
  }

  let yazi_id = $env.YAZI_ID
  if ($yazi_id | is-empty) {
    print "Warning: YAZI_ID not set in this environment. Yazi navigation may fail."
  }

  let tab_id = kitty @ ls --match 'title:SIDEBAR' | from json | get id | get 0;
  # wlog $"tab id => ($tab_id); type => ($tab_id | describe)"
  if (is_editor_running) {
    focus_helix
    open_file_in_existing_helix $file_path
  } else {
    open_file_in_new_helix_window $file_path $yazi_id $tab_id
  }
}
