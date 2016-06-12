#!/bin/bash

touch /var/log/kaa/kaa-node.log;

. /kaa/configure-kaa.sh || exit 1;
echo "Kaa configured!"

echo "Waiting for JDBC to be ready (${JDBC_HOST}:${JDBC_PORT}) ..."
while ! timeout 1 bash -c "cat < /dev/null > /dev/tcp/${JDBC_HOST}/${JDBC_PORT}" >/dev/null 2>/dev/null; do sleep 0.1; done
echo "JDBC is now ready! Resuming container start..."

service kaa-node start &
. /kaa/tail-node.sh

/bin/bash