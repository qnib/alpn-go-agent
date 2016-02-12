#!/usr/local/bin/dumb-init /bin/bash

/opt/go-agent/agent.sh 2>&1 1>/var/log/gocd-agent.log
echo $$ > /opt/go-agent/go-agent.pid
tail -f /var/log/gocd-agent.log
