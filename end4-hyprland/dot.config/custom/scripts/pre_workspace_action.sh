#!/usr/bin/env bash
curr_workspace="$(hyprctl activeworkspace -j | jq -r ".id")"

dispatcher="$1"
shift ## The target is now in $1, not $2

if [[ -z "${dispatcher}" || "${dispatcher}" == "--help" || "${dispatcher}" == "-h" || -z "$1" ]]; then
  echo "Usage: $0 <dispatcher> <target>"
  exit 1
fi
if [[ "${curr_workspace}" -eq "$1" ]]; then
  hyprctl dispatch workspace previous
else
  # otherwise, switch to the target workspace with standard script from ~/.config/hypr/hyprland/keybinds.conf
  exec ~/.config/hypr/hyprland/scripts/workspace_action.sh "$dispatcher" "$1"
fi
