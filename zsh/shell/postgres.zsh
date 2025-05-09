#!/bin/zsh

db_staging () {
  printf "Connecting to staging DB...\n" >&2;\
  ssh -f staging sleep 10 && pgcli -d $STAGING_DB_URL
}

db_prod () {
  printf "Connecting to production DB...be careful!!!\n" >&2;\
  ssh -f prod sleep 10 && pgcli -d $PROD_DB_URL
}

db_prod_read_only () {
  printf "Connecting to read-only production DB...\n" >&2;\
    ssh -f prod_read_only sleep 10 && pgcli -d $PROD_READ_ONLY_DB_URL
}

db_sandbox () {
  printf "Connecting to sandbox DB...\n" >&2;\
  ssh -f sandbox sleep 10 && pgcli -d $SANDBOX_DB_URL
}

db_dev () {
  pgcli -d $DEV_DATABASE_URL
}

