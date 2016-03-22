#!/bin/bash -x

## Kaa Docker configurator
## - Christopher Burroughs @ xMight Inc. <chris@xmight.com>

# If a ZooKeeper container is linked with the alias `zookeeper`, use it.
# You MUST set ZOOKEEPER_IP in env otherwise.
[ -n "$ZOOKEEPER_PORT_2181_TCP_ADDR" ] && ZOOKEEPER_IP=$ZOOKEEPER_PORT_2181_TCP_ADDR
[ -n "$ZOOKEEPER_PORT_2181_TCP_PORT" ] && ZOOKEEPER_PORT=$ZOOKEEPER_PORT_2181_TCP_PORT

# Get container's localhost IP (127.0.0.1 most cases)
IP=$(cat /etc/hosts | head -n1 | awk '{print $1}')

# Concatenate the IP:PORT for ZooKeeper to allow setting a full connection
# string with multiple ZooKeeper hosts
[ -z "$ZOOKEEPER_CONNECTION_STRING" ] && ZOOKEEPER_CONNECTION_STRING="${ZOOKEEPER_IP}:${ZOOKEEPER_PORT:-2181}"

# Check if JDBC host:port + DB name are provided, then build JDBC URL
[ -n "$JDBC_HOST" ] || JDBC_HOST="localhost"
[ -n "$JDBC_PORT" ] || JDBC_PORT="5432"
[ -n "$DAO_DB_NAME" ] || DAO_DB_NAME="kaa"
JDBC_URL="jdbc:postgresql://${JDBC_HOST}:${JDBC_PORT}/${DAO_DB_NAME}"

#TRANSPORT_PUBLIC_INTERFACE=$HOSTIP

# > admin-dao.properties
cat /usr/lib/kaa-node/conf/admin-dao.properties.template | sed \
  -e "s|{{JDBC_USERNAME}}|${JDBC_USERNAME:-postgres}|g" \
  -e "s|{{JDBC_PASSWORD}}|${JDBC_PASSWORD:-admin}|g" \
  -e "s|{{JDBC_URL}}|${JDBC_URL}|g" \
   > /usr/lib/kaa-node/conf/admin-dao.properties

# > common-dao-cassandra.properties
CASSANDRA_NODE_LIST_DEFAULT="127.0.0.1:9042"
cat /usr/lib/kaa-node/conf/common-dao-cassandra.properties.template | sed \
  -e "s|{{CASSANDRA_CLUSTER_NAME}}|${CASSANDRA_CLUSTER_NAME:-Kaa Cluster}|g" \
  -e "s|{{CASSANDRA_KEYSPACE_NAME}}|${CASSANDRA_KEYSPACE_NAME:-kaa}|g" \
  -e "s|{{CASSANDRA_NODE_LIST}}|${CASSANDRA_NODE_LIST:-$CASSANDRA_NODE_LIST_DEFAULT}|g" \
  -e "s|{{CASSANDRA_USE_SSL}}|${CASSANDRA_USE_SSL:-false}|g" \
  -e "s|{{CASSANDRA_USE_JMX}}|${CASSANDRA_USE_JMX:-true}|g" \
  -e "s|{{CASSANDRA_USE_CREDENTIALS}}|${CASSANDRA_USE_CREDENTIALS:-false}|g" \
  -e "s|{{CASSANDRA_USERNAME}}|${CASSANDRA_USERNAME:-}|g" \
  -e "s|{{CASSANDRA_PASSWORD}}|${CASSANDRA_PASSWORD:-}|g" \
   > /usr/lib/kaa-node/conf/common-dao-cassandra.properties

# > common-dao-mongodb.properties
MONGODB_NODE_LIST_DEFAULT="localhost:27017"
cat /usr/lib/kaa-node/conf/common-dao-mongodb.properties.template | sed \
  -e "s|{{MONGODB_NODE_LIST}}|${MONGODB_NODE_LIST:-$MONGODB_NODE_LIST_DEFAULT}|g" \
  -e "s|{{MONGODB_DB_NAME}}|${MONGODB_DB_NAME:-kaa}|g" \
  -e "s|{{MONGODB_WRITE_CONCERN}}|${MONGODB_WRITE_CONCERN:-acknowledged}|g" \
   > /usr/lib/kaa-node/conf/common-dao-mongodb.properties

# > dao.properties
NOSQL_DB_PROVIDER_NAME_DEFAULT="mongodb"
cat /usr/lib/kaa-node/conf/dao.properties.template | sed \
  -e "s|{{DAO_DB_NAME}}|${DAO_DB_NAME}|g" \
  -e "s|{{NOSQL_DB_PROVIDER_NAME}}|${NOSQL_DB_PROVIDER_NAME:-$NOSQL_DB_PROVIDER_NAME_DEFAULT}|g" \
  -e "s|{{JDBC_USERNAME}}|${JDBC_USERNAME:-postgres}|g" \
  -e "s|{{JDBC_PASSWORD}}|${JDBC_PASSWORD:-admin}|g" \
  -e "s|{{JDBC_HOST}}|${JDBC_HOST}|g" \
  -e "s|{{JDBC_PORT}}|${JDBC_PORT}|g" \
   > /usr/lib/kaa-node/conf/dao.properties

cat /usr/lib/kaa-node/conf/kaa-node.properties.template | sed \
  -e "s|{{CONTROL_SERVER_ENABLED}}|${CONTROL_SERVER_ENABLED:-true}|g" \
  -e "s|{{BOOTSTRAP_SERVER_ENABLED}}|${BOOTSTRAP_SERVER_ENABLED:-true}|g" \
  -e "s|{{OPERATIONS_SERVER_ENABLED}}|${OPERATIONS_SERVER_ENABLED:-true}|g" \
  -e "s|{{THRIFT_HOST}}|${THRIFT_HOST:-localhost}|g" \
  -e "s|{{THRIFT_PORT}}|${THRIFT_PORT:-9090}|g" \
  -e "s|{{ADMIN_PORT}}|${ADMIN_PORT:-8080}|g" \
  -e "s|{{ZOOKEEPER_CONNECTION_STRING}}|${ZOOKEEPER_CONNECTION_STRING}|g" \
  -e "s|{{SUPPORT_UNENCRYPTED_CONNECTION}}|${SUPPORT_UNENCRYPTED_CONNECTION:-true}|g" \
  -e "s|{{TRANSPORT_BIND_INTERFACE}}|${TRANSPORT_BIND_INTERFACE:-0.0.0.0}|g" \
  -e "s|{{TRANSPORT_PUBLIC_INTERFACE}}|${TRANSPORT_PUBLIC_INTERFACE:-localhost}|g" \
  -e "s|{{METRICS_ENABLED}}|${METRICS_ENABLED:-true}|g" \
   > /usr/lib/kaa-node/conf/kaa-node.properties