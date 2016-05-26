#!/bin/sh

# Suggestion: create a docker network (say "kaa"), add all the required containers to this network, then run this script.

docker run \
-d \
--name kaa \
--net=kaa \
--env-file example-env.dockerenv \
-p 8080:8080 \
-p 9888:9888 \
-p 9889:9889 \
-p 9997:9997 \
-p 9997:9997 \
xmight/kaa:0.9.0

# To view logs:
# $ docker logs kaa
