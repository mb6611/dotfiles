#!/usr/bin/env bash
# Toggle the dev session popup. If open, dismiss; if closed, reopen at whatever
# window was last active in dev (tmux remembers this per-session automatically).
# If dev doesn't exist yet, do nothing — summon a repo first to bootstrap it.

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
set -e

# Popup currently open → dismiss
if tmux list-clients -F "#{session_name}" 2>/dev/null | grep -qx "dev"; then
  tmux detach-client -s dev
  exit 0
fi

# No dev session → nothing to summon
tmux has-session -t dev 2>/dev/null || exit 0

# Bring iTerm forward only if invoked from outside it
INTERNAL=0
if [ -n "$TMUX" ]; then
  INTERNAL=1
else
  FRONT=$(lsappinfo info -only name "$(lsappinfo front)" 2>/dev/null | awk -F'"' '{print $4}')
  [ "$FRONT" = "iTerm2" ] && INTERNAL=1
fi
[ "$INTERNAL" -eq 0 ] && open -a iTerm >/dev/null 2>&1

tmux display-popup -E -w 90% -h 90% "tmux attach -t dev"
