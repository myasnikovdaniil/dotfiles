#!/bin/bash
#set -x -e

# Get the ID of the currently active window in sway
ACTIVE_WINDOW=$(swaymsg -t get_tree | jq -r '
recurse(.nodes[])
| select(.focused)
| .id')

# Get the class of the active window
WINDOW_CLASS=$(swaymsg -t get_tree | jq -r "
recurse(.nodes[])
| select(.id == $ACTIVE_WINDOW)
| .app_id")

# Check if the active window is Alacritty
if [ "$WINDOW_CLASS" == "Alacritty" ]; then
  # Use swaymsg to get the process ID of the focused Alacritty window
  WINDOW_PID=$(swaymsg -t get_tree | jq -r "
  recurse(.nodes[])
  | select(.id == $ACTIVE_WINDOW)
  | .pid")

  # Find the child zsh process
  ZSH_PID=$(pgrep -P $WINDOW_PID zsh)

  if [ -n "$ZSH_PID" ]; then
    # Use lsof to determine the current directory of the zsh process
    ZSH_CWD=$(lsof -p $ZSH_PID | grep "cwd" | awk '{print $9}')

    if [ -n "$ZSH_CWD" ]; then
      # Launch new Alacritty instance in the same directory
      alacritty --working-directory "$ZSH_CWD"
    else
      alacritty
    fi
  else
    alacritty
  fi
else
  # Launch a new Alacritty instance without specifying the directory
  alacritty
fi
