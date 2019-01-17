#!/bin/sh
set -eo pipefail

REDIS_CONFIG_FILE_PATH=/usr/local/etc/redis/redis.conf

if [ ! -f "$REDIS_CONFIG_FILE_PATH" ]; then
	echo >&2 "healthcheck error: not found REDIS config file: ${REDIS_CONFIG_FILE_PATH})"
	exit 0
fi

redisPassword=`awk '/^ requirepass /{print $NF}' ${REDIS_CONFIG_FILE_PATH}`

host="$(hostname -i || echo '127.0.0.1')"

if ping="$(redis-cli -a $redisPassword -h "$host" ping)" && [ "$ping" = 'PONG' ]; then
	exit 0
fi

exit 1