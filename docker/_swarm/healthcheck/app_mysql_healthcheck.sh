#!/bin/bash
set -eo pipefail

if [ "$MYSQL_ROOT_PASSWORD_FILE" ] && [ -z "$MYSQL_USER_FILE" ] && [ -z "$MYSQL_PASSWORD_FILE" ]; then
	# there's no way we can guess what the random MySQL password was
	echo >&2 'healthcheck error: cannot determine random root password (and MYSQL_USER_FILE and MYSQL_PASSWORD_FILE were not set)'
	exit 0
fi

mysqlUser=`cat ${MYSQL_USER_FILE}`
mysqlPassword=`cat ${MYSQL_PASSWORD_FILE}`
mysqlRootPassword=`cat ${MYSQL_ROOT_PASSWORD_FILE}`


host="$(hostname --ip-address || echo '127.0.0.1')"
user="${mysqlUser:-root}"
export MYSQL_PWD="${mysqlPassword:-$mysqlRootPassword}"


args=(
	# force mysql to not use the local "mysqld.sock" (test "external" connectibility)
	-h"$host"
	-u"$user"
	--silent
)

if command -v mysqladmin &> /dev/null; then
	if mysqladmin "${args[@]}" ping > /dev/null; then
		exit 0
	fi
else
	if select="$(echo 'SELECT 1' | mysql "${args[@]}")" && [ "$select" = '1' ]; then
		exit 0
	fi
fi

exit 1