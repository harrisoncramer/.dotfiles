HOST_NAME=$(hostname)

# Source sensitive values for work/personal
if [ "$HOST_NAME" = "harry-work-computer" ]; then
  source ~/.zshrc-work
  if [ -z "$GITHUB_TOKEN" ]; then
    GITHUB_TOKEN=$(op item get 'Github API Token' --fields 'api_token' --reveal)
    export GITHUB_TOKEN=$GITHUB_TOKEN
  fi
  if [ -z "$PROD_DB_URL" ]; then
    PROD_PWD=$(op read op://Development/db_prod/password)
    export PROD_DB_URL="postgresql://chariot:${PROD_PWD}@localhost:5431/chariot"
  fi

  if [ -z "$STAGING_DB_URL" ]; then
    STAGING_PWD=$(op read op://Development/db_staging/credential)
    export STAGING_DB_URL="postgresql://chariot:${STAGING_PWD}@localhost:5434/chariot"
  fi

  if [ -z "$PROD_READ_ONLY_DB_URL" ]; then
    PROD_READ_ONLY_PWD=$(op read op://Development/db_prod/password)
    export PROD_READ_ONLY_DB_URL="postgresql://chariot:${PROD_READ_ONLY_PWD}@localhost:5433/chariot"
  fi

  if [ -z "$SANDBOX_DB_URL" ]; then
    SANDBOX_PWD=$(op read op://Development/db_sandbox/credential)
    export SANDBOX_DB_URL="postgresql://chariot:${SANDBOX_PWD}@localhost:5435/chariot"
  fi

  if [ -z "$DEV_DATABASE_URL" ]; then
    export DEV_DATABASE_URL="postgresql://chariot:samplepassword@0.0.0.0:5432/chariot?connect_timeout=300"
  fi
else
  source ~/.zshrc-personal
  # if [[ -z $GITHUB_API_TOKEN ]]; then
  #   export GITHUB_API_TOKEN=$(op item get 'Github API Token' --fields 'api_token' --reveal)
  # fi
fi
