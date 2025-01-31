getDbUrl() {
  case "$1" in
    'prod')
      PROD_PWD=$(op read op://Development/db_prod/password)
      PROD_DB_URL="postgresql://chariot:${PROD_PWD}@localhost:5431/chariot";
      echo $PROD_DB_URL
      ;;
    'staging')
      STAGING_PWD=$(op read op://Development/db_staging/credential)
      STAGING_DB_URL="postgresql://chariot:${STAGING_PWD}@localhost:5434/chariot";
      echo $STAGING_DB_URL
      ;;
    'dev')
      echo $DEV_DATABASE_URL
      ;;
    'prod_read_only')
      PROD_READ_ONLY_PWD=$(op read op://Development/db_prod/password)
      PROD_READ_ONLY_DB_URL="postgresql://chariot:${PROD_READ_ONLY_PWD}@localhost:5433/chariot";
      echo $PROD_READ_ONLY_DB_URL
      ;;
    'sandbox')
      SANDBOX_PWD=$(op read op://Development/db_sandbox/credential)
      SANDBOX_DB_URL="postgresql://chariot:${SANDBOX_PWD}@localhost:5435/chariot";
      echo $SANDBOX_DB_URL
      ;;
    *)
      exit 1
      ;;
  esac
}
