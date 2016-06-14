#!/bin/bash

touch /var/log/kaa/kaa-node.log;

. /kaa/configure-kaa.sh || exit 1;
echo "Kaa configured!"

[[ $SERVICES_WAIT_TIMEOUT == ?(-)+([0-9]) ]] || SERVICES_WAIT_TIMEOUT=10;

# Loop through all ZK nodes
# Passes if one node is reachable
isZKReachable() {
	OIFS="$IFS"
	IFS="," read -r -a ZNODE <<< $ZOOKEEPER_NODE_LIST
	for i in "${!ZNODE[@]}"
	do
		# echo "Reaching node #$i: ${ZNODE[i]}"
		HOST=$(echo ${ZNODE[i]} | cut -f1 -d:)
		PORT=$(echo ${ZNODE[i]} | cut -f2 -d:)
		bash -c "until [[ $(echo ruok | nc -q 2 $HOST $PORT) = imok ]]; do sleep 0.1; done;" >/dev/null 2>/dev/null && return 0;
	done
	IFS=OIFS;

	# No ZK nodes were reachable
	return 1;
}

# Exit if ZK not reachable after $SERVICE_WAIT_TIMEOUT
waitForZK() {
	echo "Waiting for Zookeeper nodes: $ZOOKEEPER_NODE_LIST"

	local I=0
	until [ ! $SERVICES_WAIT_TIMEOUT -lt 0 ] && [ $I -gt $SERVICES_WAIT_TIMEOUT ]; do
		isZKReachable && echo "Zookeeper is reachable, proceeding..." && return 0;
			
		sleep 1;
		let I=I+1;
	done;

	echo "Zookeeper is unreachable, aborting!";
	exit 1;
}

isSQLReachable() {
	bash -c "cat < /dev/null > /dev/tcp/${JDBC_HOST}/${JDBC_PORT}" >/dev/null 2>/dev/null \
		&& return 0 \
		|| return 1;
}

# Exit if ZK not reachable after $SERVICE_WAIT_TIMEOUT
waitForSQL() {
	echo "Waiting for SQL ($JDBC_HOST:$JDBC_PORT)"

	local I=0
	until [ ! $SERVICES_WAIT_TIMEOUT -lt 0 ] && [ $I -gt $SERVICES_WAIT_TIMEOUT ]; do
		isSQLReachable && echo "SQL is reachable, proceeding..." && return 0;

		sleep 1;
		let I=I+1;
	done;

	echo "SQL is unreachable, aborting!";
	exit 1;
}

# Wait for ZK and SQL provider
waitForZK
waitForSQL

service kaa-node start &
. /kaa/tail-node.sh

/bin/bash
exit 0;