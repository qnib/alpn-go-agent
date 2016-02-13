#!/usr/local/bin/dumb-init /bin/bash

if [ "X${GOCD_AGENT_AUTOENABLE_KEY}" != "X" ];then
    sed -i -e "s/agent.auto.register.key=.*/agent.auto.register.key=${GOCD_AGENT_AUTOENABLE_KEY}/" /opt/go-agent/config/autoregister.properties
fi

if [ "X${GOCD_LOCAL_DOCKERENGINE}" == "Xtrue" ];then
    sed -i -e 's/agent.auto.register.resource=*/agent.auto.register.resources=docker-engine/' /opt/go-agent/config/autoregister.properties
fi

/opt/go-agent/agent.sh 2>&1 1>/var/log/gocd-agent.log
echo $$ > /opt/go-agent/go-agent.pid
tail -f /var/log/gocd-agent.log
