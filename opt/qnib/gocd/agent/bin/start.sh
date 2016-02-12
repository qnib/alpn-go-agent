#!/usr/local/bin/dumb-init /bin/bash

/opt/go-server/server.sh 2>&1 1>/var/log/go-server.log
echo $$ > /opt/go-server/go-server.pid
tail -f /var/log/go-server.log
