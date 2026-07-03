#!/usr/bin/env bash
# spotify-any.sh — tmux status segment for "now playing"
#
# Shows whatever is ACTUALLY playing, whether that's the Spotify desktop app
# OR spotify-player (the TUI backed by spotifyd). dracula's stock `mac-player`
# plugin only sees GUI apps via AppleScript, so it prints "No App Supported"
# when you're living in the spotify-player TUI. This checks both sources.
#
# Priority: "actively playing wins". Spotify Connect only ever has ONE active
# device, so play-state is the reliable tiebreaker when both happen to be open.
#   spotify_player CLI (account-global via the Web API) is preferred; the
#   AppleScript desktop check is the fallback for when the TUI isn't running.

export LC_ALL=en_US.UTF-8

PLAY_ICON="♪ "
PAUSE_ICON="❚❚ "
MAX_LENGTH=50               # truncate long "Artist - Track" strings
RATE=5                      # seconds between real refreshes (rest served from cache)
CACHE="/tmp/tmux_spotify_any_cache"

# --- source 1: spotify-player (TUI / spotifyd) ------------------------------
# `spotify_player get key playback` queries the Spotify Web API, so it reports
# the account's active playback regardless of device. Emits "STATE<TAB>track".
tui_status() {
  pgrep -x spotify_player >/dev/null 2>&1 || return   # not running → skip (avoids hangs)
  command -v jq >/dev/null 2>&1 || return
  local json playing track
  json=$(spotify_player get key playback 2>/dev/null) || return
  [ -z "$json" ] && return
  playing=$(jq -r '.is_playing // empty' <<<"$json" 2>/dev/null)
  [ -z "$playing" ] && return
  track=$(jq -r '.item | "\(.artists | map(.name) | join(", ")) - \(.name)"' <<<"$json" 2>/dev/null)
  { [ -z "$track" ] || [ "$track" = " - " ]; } && return
  [ "$playing" = "true" ] && printf 'playing\t%s' "$track" || printf 'paused\t%s' "$track"
}

# --- source 2: desktop Spotify / Music (AppleScript) ------------------------
# Only reached when spotify_player isn't running. Emits "STATE<TAB>track".
# NOTE: app names must be LITERAL in `tell application "..."` — a variable name
# stops AppleScript loading the app dictionary, so `player state`/`current track`
# would fail to compile. Spotify and Music share the same terminology.
app_status() {
  osascript <<'APPLESCRIPT'
set out to ""
if (running of application "Spotify") then
  tell application "Spotify"
    if player state is not stopped then
      set stateWord to "playing"
      if player state is paused then set stateWord to "paused"
      set out to stateWord & tab & (artist of current track) & " - " & (name of current track)
    end if
  end tell
end if
if out is "" and (running of application "Music") then
  tell application "Music"
    if player state is not stopped then
      set stateWord to "playing"
      if player state is paused then set stateWord to "paused"
      set out to stateWord & tab & (artist of current track) & " - " & (name of current track)
    end if
  end tell
end if
return out
APPLESCRIPT
}

# --- render one "STATE<TAB>track" line into the cache -----------------------
render() {
  local line="$1" icon out state track
  [ -z "$line" ] && { : > "$CACHE"; return; }   # nothing playing → empty segment
  state="${line%%$'\t'*}"
  track="${line#*$'\t'}"
  [ "$state" = "playing" ] && icon="$PLAY_ICON" || icon="$PAUSE_ICON"
  out="${icon}${track}"
  [ "${#out}" -gt "$MAX_LENGTH" ] && out="${out:0:$MAX_LENGTH}..."
  printf '%s' "$out" > "$CACHE"
}

# --- pick the winner: actively playing wins, CLI preferred ------------------
refresh() {
  local tui app
  tui=$(tui_status)
  [ "${tui%%$'\t'*}" = "playing" ] && { render "$tui"; return; }  # common case, skip osascript

  app=$(app_status)
  [ "${app%%$'\t'*}" = "playing" ] && { render "$app"; return; }  # desktop app playing

  # nothing actively playing — show whichever has a paused track (TUI preferred)
  if   [ -n "$tui" ]; then render "$tui"
  elif [ -n "$app" ]; then render "$app"
  else render ""
  fi
}

# Cache so a fast status redraw doesn't spawn osascript/jq every frame.
if [ ! -f "$CACHE" ] || [ "$(( $(date +%s) - $(stat -f %m "$CACHE" 2>/dev/null || echo 0) ))" -ge "$RATE" ]; then
  refresh
fi
cat "$CACHE"
