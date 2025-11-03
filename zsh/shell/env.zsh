#!/bin/zsh

HOST_NAME=$(hostname)

# Gets a secret from the OnePassword vault with the label provided and tagged with "mise"
getSecret() {
    set +e
    secret=$(op item get "$1" --vault "$2" --field "$3" 2>/dev/null)
    set -e
    if [[ -z "$secret" ]]; then
        echo
        gum log --level error "Error: Failed to get \"$1\" secret." >&2
        return 1
    fi
    echo "$secret"
}


# Source sensitive values for work/personal
if [ "$HOST_NAME" = "harry-work-computer" ]; then

  export API_KEY="sk_dev_b970c548bb13bbd6b16dab9f55fa05af" # Local only, not sensitive!

  if [ -z "$GITHUB_TOKEN" ]; then
    GITHUB_TOKEN=$(op item get 'Github API Token' --fields 'api_token' --reveal)
    export GITHUB_TOKEN=$GITHUB_TOKEN
  fi
  if [ -z "$PROD_DATABASE_URL" ]; then
    export PROD_DATABASE_URL=$(getSecret 'Mise Secrets' 'Development' 'PROD_DATABASE_URL')
  fi

  if [ -z "$STAGING_DATABASE_URL" ]; then
    export STAGING_DATABASE_URL=$(getSecret 'Mise Secrets' 'Development' 'STAGING_DATABASE_URL')
  fi

  if [ -z "$PROD_READ_ONLY_DATABASE_URL" ]; then
    export PROD_READ_ONLY_DATABASE_URL=$(getSecret 'Mise Secrets' 'Development' 'PROD_READ_ONLY_DATABASE_URL')
  fi

  if [ -z "$SANDBOX_DATABASE_URL" ]; then
    export SANDBOX_DATABASE_URL=$(getSecret 'Mise Secrets' 'Development' 'SANDBOX_DATABASE_URL')
  fi

  if [ -z "$DEV_DATABASE_URL" ]; then
    export DEV_DATABASE_URL="postgresql://chariot:samplepassword@0.0.0.0:5432/chariot?connect_timeout=300"
  fi

  if [ -z "$ANTHROPIC_API_KEY" ]; then
    export ANTHROPIC_API_KEY=$(op item get 'Anthropic API Token' --fields 'api_token' --reveal)
  fi
else
  source ~/.zshrc-personal
  # if [[ -z $GITHUB_API_TOKEN ]]; then
  #   export GITHUB_API_TOKEN=$(op item get 'Github API Token' --fields 'api_token' --reveal)
  # fi
fi
