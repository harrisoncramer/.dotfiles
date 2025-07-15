#!/bin/bash

PAGER="/Users/harrisoncramer/.local/bin/nvim-macos/bin/nvim"
PAGER_MAN="$PAGER +Man!"
PAGER_CAT="$PAGER -"

help() {

  if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <command>"
    exit 1
  fi

  CMD="$1"

  # Try man page first
  if man -w "$CMD" >/dev/null 2>&1; then
    MANPAGER="$PAGER_MAN" man "$CMD"
    exit 0
  fi

  # Try common help flags
  for flag in "--help" "-h" "help" "-help"; do
    # Try "$CMD <flag>" as both "cmd --help" & "cmd help"
    if OUTPUT=$("$CMD" $flag 2>&1); then
      if [[ -n "$OUTPUT" ]]; then
        printf "%s\n" "$OUTPUT" | $PAGER_CAT
        exit 0
      fi
    fi
  done

  echo "No man page or help output found for '$CMD'"

}
