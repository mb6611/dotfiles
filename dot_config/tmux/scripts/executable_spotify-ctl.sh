#!/usr/bin/env bash
# spotify-ctl.sh — remote control that mirrors the status display's logic:
# prioritize spotify-player (the TUI) when it's running, otherwise fall back to
# driving the Spotify desktop app via AppleScript (what the old plugin did).
#
# Usage: spotify-ctl.sh {toggle|next|prev}

action="$1"

if pgrep -x spotify_player >/dev/null 2>&1; then
  case "$action" in
    toggle) spotify_player playback play-pause ;;
    next)   spotify_player playback next ;;
    prev)   spotify_player playback previous ;;
  esac
else
  case "$action" in
    toggle) osascript -e 'tell application "Spotify" to playpause' ;;
    next)   osascript -e 'tell application "Spotify" to play next track' ;;
    prev)   osascript -e 'tell application "Spotify" to previous track' ;;
  esac
fi
