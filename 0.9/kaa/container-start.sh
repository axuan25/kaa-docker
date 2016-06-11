#!/bin/bash

touch /var/log/kaa/kaa-node.log;

. /kaa/configure-kaa.sh || exit 1;
echo "Kaa configured! Starting service..."

service kaa-node start &
. /kaa/tail-node.sh

/bin/bash