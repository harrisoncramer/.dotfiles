#!/bin/zsh

dc() {
  docker-compose --project-name chariot -f "$MONO_DIR/docker-compose.yml" --env-file "$MONO_DIR/.env" "$@"
}

down() {
  dc down $@
}
purge() {
  dc rm -s -f $@
  CONTAINER=$(docker image ls | grep $@ | awk '{print $3}')
  if [ -n "$CONTAINER" ]; then
    docker rmi  $CONTAINER
  fi
}
stop() {
  dc stop $@
}
start() {
  dc up $@ -d && logs $@
}

logs () {
  mise run docker:logs "$@"
  # logfile="/tmp/logs_buffer.txt"
  # rm -f "$logfile"  # Clear previous logs
  # touch "$logfile"
  #
  # (dc logs --no-log-prefix "$@" -f >> "$logfile" 2>/dev/null) &
  # pid=$!
  #
  # # Start in tailing mode by default
  # tail -n 100000 -f "$logfile" | fzf --tac --no-sort --exact --wrap \
  #     --bind 'tab:toggle' \
  #     --bind "ctrl-e:execute:echo {} | awk -F':' '{file=substr(\$1, 2); print \"+\"\$2, ENVIRON[\"MONO_DIR\"]file}' | xargs /Users/harrisoncramer/.local/bin/nvim-macos/bin/nvim" \
  #     --bind 'enter:execute:echo {} | pbcopy' \
  #     --bind 'esc:abort' \
  #     --bind 'ctrl-t:reload(cat '"$logfile"')' \
  #     --bind 'ctrl-r:reload(tail -n 100000 -f '"$logfile"')'
  #
  # pkill $pid
}

attach() {
  docker exec -it $@ /bin/bash
}

