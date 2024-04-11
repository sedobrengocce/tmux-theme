# Copyright (c) 2024-present Giuseppe Tufo
# This source code is licensed under the MIT license found in the license file.

PEPJ_TMUX_COLOR_THEME_FILE="src/pepj.conf"
PEPJ_TMUX_VERSION=1.0.0
PEPJ_TMUX_STATUS_CONTENT_FILE="src/pepj-status-content.conf"
PEPJ_TMUX_STATUS_CONTENT_NO_PATCHED_FONT_FILE="src/pepj-status-content-no-patched-font.conf"
PEPJ_TMUX_STATUS_CONTENT_OPTION="@pepj_tmux_show_status_content"
PEPJ_TMUX_STATUS_CONTENT_DATE_FORMAT="@pepj_tmux_date_format"
PEPJ_TMUX_NO_PATCHED_FONT_OPTION="@pepj_tmux_no_patched_font"
_current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PEPJ_TMUX_BATTERY_STATUS=($_current_dir/src/pepj_battery_status.sh)

__cleanup() {
  unset -v PEPJ_TMUX_COLOR_THEME_FILE PEPJ_TMUX_VERSION
  unset -v PEPJ_TMUX_STATUS_CONTENT_FILE PEPJ_TMUX_STATUS_CONTENT_NO_PATCHED_FONT_FILE
  unset -v PEPJ_TMUX_STATUS_CONTENT_OPTION PEPJ_TMUX_NO_PATCHED_FONT_OPTION
  unset -v PEPJ_TMUX_STATUS_CONTENT_DATE_FORMAT
  unset -v _current_dir
  unset -f __load __cleanup
  tmux set-environment -gu PEPJ_TMUX_STATUS_TIME_FORMAT
  tmux set-environment -gu PEPJ_TMUX_STATUS_DATE_FORMAT
}

__load() {
  tmux source-file "$_current_dir/$PEPJ_TMUX_COLOR_THEME_FILE"



  local status_content=$(tmux show-option -gqv "$PEPJ_TMUX_STATUS_CONTENT_OPTION")
  local no_patched_font=$(tmux show-option -gqv "$PEPJ_TMUX_NO_PATCHED_FONT_OPTION")
  local date_format=$(tmux show-option -gqv "$PEPJ_TMUX_STATUS_CONTENT_DATE_FORMAT")

  if [ "$(tmux show-option -gqv "clock-mode-style")" == '12' ]; then
    tmux set-environment -g PEPJ_TMUX_STATUS_TIME_FORMAT "%I:%M %p"
  else
    tmux set-environment -g PEPJ_TMUX_STATUS_TIME_FORMAT "%H%M"
  fi

  if [ -z "$date_format" ]; then
    tmux set-environment -g PEPJ_TMUX_STATUS_DATE_FORMAT "%Y%m%d"
  else
    tmux set-environment -g PEPJ_TMUX_STATUS_DATE_FORMAT "$date_format"
  fi

  if [ "$status_content" != "0" ]; then
    if [ "$no_patched_font" != "1" ]; then
      tmux source-file "$_current_dir/$PEPJ_TMUX_STATUS_CONTENT_FILE"
    else
      tmux source-file "$_current_dir/$PEPJ_TMUX_STATUS_CONTENT_NO_PATCHED_FONT_FILE"
    fi
  fi
}

__load
__cleanup
