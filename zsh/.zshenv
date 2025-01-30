setDbUrls() {
  PROD_PWD=$(op read op://Development/db_prod/password)
  PROD_DB_URL="postgresql://chariot:${PROD_PWD}@localhost:5431/chariot";
  export PROD_DB_URL
  STAGING_PWD=$(op read op://Development/db_staging/credential)
  STAGING_DB_URL="postgresql://chariot:${STAGING_PWD}@localhost:5434/chariot";
  export STAGING_DB_URL
  PROD_READ_ONLY_PWD=$(op read op://Development/db_prod/password)
  PROD_READ_ONLY_DB_URL="postgresql://chariot:${PROD_READ_ONLY_PWD}@localhost:5433/chariot";
  export PROD_READ_ONLY_DB_URL
  SANDBOX_PWD=$(op read op://Development/db_sandbox/credential)
  SANDBOX_DB_URL="postgresql://chariot:${SANDBOX_PWD}@localhost:5435/chariot";
  export SANDBOX_DB_URL
}

