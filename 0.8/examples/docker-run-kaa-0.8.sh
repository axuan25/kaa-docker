#!/bin/sh

docker run \
-d \
--name kaa \
--link zookeeper:zookeeper \
--link postgres:postgresql \
--link mongo:mongodb \
--env-file example-env.dockerenv \
-p 8080:8080 \
-p 9888:9888 \
-p 9889:9889 \
-p 9997:9997 \
-p 9999:9999 \
xmight/kaa:0.8.1