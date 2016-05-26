#!/bin/bash -x

## Kaa Docker configurator
## - Christopher Burroughs @ xMight Inc. <chris@xmight.com>


# Check if Zookeeper host + port are provided, then build ZK connection string.
# If multiple ZK hosts exist, then only provide ZOOKEEPER_CONNECTION_STRING in the environment file.
[ -n "$ZOOKEEPER_HOST" ] || ZOOKEEPER_HOST="localhost"
[ -n "$ZOOKEEPER_PORT" ] || ZOOKEEPER_PORT="2181"
[ -n "$ZOOKEEPER_CONNECTION_STRING" ] || ZOOKEEPER_CONNECTION_STRING="${ZOOKEEPER_HOST}:${ZOOKEEPER_PORT}"

# Check if JDBC host:port + DB name are provided, then build JDBC URL
[ -n "$JDBC_HOST" ] || JDBC_HOST="localhost"
[ -n "$JDBC_PORT" ] || JDBC_PORT="3306"
[ -n "$JDBC_DB_NAME" ] || JDBC_DB_NAME="kaa"
JDBC_URL="jdbc:mysql:failover://${JDBC_HOST}:${JDBC_PORT}/${JDBC_DB_NAME}"

## TODO: use same technique for cassandra/mongo

## Process configuration templates ##

# > admin-dao.properties
cat /usr/lib/kaa-node/conf/admin-dao.properties.template | sed \
  -e "s|{{JDBC_USERNAME}}|${JDBC_USERNAME:-sqladmin}|g" \
  -e "s|{{JDBC_PASSWORD}}|${JDBC_PASSWORD:-admin}|g" \
  -e "s|{{JDBC_URL}}|${JDBC_URL}|g" \
   > /usr/lib/kaa-node/conf/admin-dao.properties

# > sql-dao.properties
cat /usr/lib/kaa-node/conf/sql-dao.properties.template | sed \
  -e "s|{{JDBC_DB_NAME}}|${JDBC_DB_NAME}|g" \
  -e "s|{{JDBC_USERNAME}}|${JDBC_USERNAME:-sqladmin}|g" \
  -e "s|{{JDBC_PASSWORD}}|${JDBC_PASSWORD:-admin}|g" \
  -e "s|{{JDBC_HOST}}|${JDBC_HOST}|g" \
  -e "s|{{JDBC_PORT}}|${JDBC_PORT}|g" \
   > /usr/lib/kaa-node/conf/sql-dao.properties

# > mariadb-dao.properties
cat /usr/lib/kaa-node/conf/mariadb-dao.properties.template | sed \
  -e "s|{{JDBC_USERNAME}}|${JDBC_USERNAME:-sqladmin}|g" \
  -e "s|{{JDBC_PASSWORD}}|${JDBC_PASSWORD:-admin}|g" \
  -e "s|{{JDBC_URL}}|${JDBC_URL}|g" \
   > /usr/lib/kaa-node/conf/mariadb-dao.properties

# > postgresql-dao.properties
cat /usr/lib/kaa-node/conf/postgresql-dao.properties.template | sed \
  -e "s|{{JDBC_USERNAME}}|${JDBC_USERNAME:-postgres}|g" \
  -e "s|{{JDBC_PASSWORD}}|${JDBC_PASSWORD:-admin}|g" \
  -e "s|{{JDBC_URL}}|${JDBC_URL}|g" \
   > /usr/lib/kaa-node/conf/postgresql-dao.properties

# > common-dao-cassandra.properties
CASSANDRA_NODE_LIST_DEFAULT="localhost:9042"
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

# > nosql-dao.properties
NOSQL_DB_PROVIDER_NAME_DEFAULT="mongodb"
cat /usr/lib/kaa-node/conf/nosql-dao.properties.template | sed \
  -e "s|{{NOSQL_DB_PROVIDER_NAME}}|${NOSQL_DB_PROVIDER_NAME:-$NOSQL_DB_PROVIDER_NAME_DEFAULT}|g" \
   > /usr/lib/kaa-node/conf/nosql-dao.properties

# > kaa-node.properties
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