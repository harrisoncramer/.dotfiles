alias claude="claude --dangerously-skip-permissions --model opus"
pgcli() {
    if [[ -t 0 ]]; then
        stty -ixon
    fi
    command pgcli "$@"
}
