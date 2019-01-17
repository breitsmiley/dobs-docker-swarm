#!/usr/bin/env bash
SWARM_SECRETS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../docker/_swarm/secrets" && pwd )"
RUN_ENV="preprod"


echo "[START] - Init SWARM secrets"
echo "-----------------------------"

# dobs-mysql-db
#------------------------------------------------
printf "dobs" | docker secret create dobsMysqlDb-MYSQL_DATABASE-v1 -
printf "dobs" | docker secret create dobsMysqlDb-MYSQL_USER-v1 -
printf "dobs" | docker secret create dobsMysqlDb-MYSQL_PASSWORD-v1 -
printf "root" | docker secret create dobsMysqlDb-MYSQL_ROOT_PASSWORD-v1 -

echo "-----------------------------"
echo "[DONE] - Init SWARM secrets"


