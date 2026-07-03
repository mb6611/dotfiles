#!/usr/bin/env bash
# Reads ~/.tmux/repos.conf and emits tmux `bind` commands for the "repo" key table.
# Output is sourced by tmux.conf at startup so adding a repo only requires editing the conf.

CONF="$HOME/.tmux/repos.conf"
[ -f "$CONF" ] || exit 0

# Clear any prior bindings in the repo table so reloads don't leave stale entries
echo "unbind-key -aT repo"

while IFS= read -r line; do
  case "$line" in
    ''|\#*) continue ;;
  esac
  key=$(echo "$line" | awk '{print $1}')
  [ -z "$key" ] && continue
  echo "bind -T repo $key run-shell '$HOME/.tmux/scripts/repo-summon.sh \"$key\"'"
done < "$CONF"
