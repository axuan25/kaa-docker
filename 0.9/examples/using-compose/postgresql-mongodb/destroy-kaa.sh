#!/bin/sh

docker-compose -p kaaiot down && \
docker volume rm kaaiot_jdbc-data kaaiot_mongo-data kaaiot_zookeeper-data
