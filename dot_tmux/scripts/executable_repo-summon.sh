#!/usr/bin/env bash
# Summon a repo as a popup attached to the "dev" session at its window.
# Toggle: pressing the same key while focused on this repo dismisses the popup.
# Repos are defined in ~/.tmux/repos.conf (format: key name path).

# Ensure tmux is on PATH when invoked from non-interactive contexts (e.g. BTT)
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

set -e

KEY="$1"
CONF="$HOME/.tmux/repos.conf"

[ -f "$CONF" ] || exit 0

LINE=$(grep -E "^${KEY}[[:space:]]" "$CONF" | head -1)
[ -z "$LINE" ] && exit 0

NAME=$(echo "$LINE" | awk '{print $2}')
REPO_PATH=$(echo "$LINE" | awk '{print $3}')
REPO_PATH="${REPO_PATH/#\$HOME/$HOME}"
REPO_PATH="${REPO_PATH/#\~/$HOME}"

# Detect context BEFORE activating anything. "Internal" = invoked from inside
# tmux (prefix table), or invoked while iTerm was already the frontmost app.
# "External" = invoked from another app (browser, Slack, etc.).
# IMPORTANT: BTT must NOT have an "Activate Application: iTerm" step before this
# script runs — that would always make iTerm look frontmost and break detection.
INTERNAL=0
if [ -n "$TMUX" ]; then
  INTERNAL=1
else
  # lsappinfo is ~10x faster than osascript for frontmost detection
  FRONT=$(lsappinfo info -only name "$(lsappinfo front)" 2>/dev/null | awk -F'"' '{print $4}')
  [ "$FRONT" = "iTerm2" ] && INTERNAL=1
fi

if ! tmux has-session -t dev 2>/dev/null; then
  tmux new-session -d -s dev -n "$NAME" -c "$REPO_PATH"
elif ! tmux list-windows -t dev -F "#W" | grep -qx "$NAME"; then
  tmux new-window -t dev: -n "$NAME" -c "$REPO_PATH"
fi

CUR_DEV_W=$(tmux list-clients -t dev -F "#{window_name}" 2>/dev/null | head -1)

# Bring iTerm forward only when called from outside it. Inside iTerm/tmux: no-op.
focus_iterm() {
  [ "$INTERNAL" -eq 0 ] && open -a iTerm >/dev/null 2>&1 || true
}

if [ -n "$CUR_DEV_W" ]; then
  if [ "$CUR_DEV_W" = "$NAME" ]; then
    # Popup already on this repo.
    # Internal → toggle dismiss (you're choosing to leave).
    # External → just bring iTerm forward; the popup is already what you want.
    if [ "$INTERNAL" -eq 1 ]; then
      tmux detach-client -s dev
    else
      focus_iterm
    fi
    exit 0
  else
    # Different repo → switch within existing popup, focus iTerm if external
    tmux select-window -t "dev:$NAME"
    focus_iterm
    exit 0
  fi
fi

# No popup → focus iTerm first (so popup lands in the visible terminal), then open
focus_iterm
tmux select-window -t "dev:$NAME"
tmux display-popup -E -w 90% -h 90% "tmux attach -t dev"
