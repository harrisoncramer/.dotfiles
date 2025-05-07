#!/bin/bash

OUTPUT="/tmp/fzf-quickfix"
echo "" > "$OUTPUT"

for arg in "$@"; do
  echo "$arg" >> "$OUTPUT"
done
