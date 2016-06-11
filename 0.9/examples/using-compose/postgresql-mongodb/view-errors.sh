#!/bin/sh

docker-compose exec kaa cat /var/log/kaa/* | grep ERROR