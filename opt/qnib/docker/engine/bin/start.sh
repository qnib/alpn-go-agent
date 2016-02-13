#!/usr/local/bin/dumb-init /bin/bash

# if the docker-sock is bind-mounted, skip the service
if [ -S /var/run/docker.sock ];then
    echo "'/var/run/docker.sock' already there (I assume it's bind-mounted), lets drop out"
    rm -f /etc/consul.d/docker-engine.json
    consul reload
    sleep 2
    exit 0
fi

docker daemon -H unix:///var/run/docker.sock --insecure-registry docker-registry.service.consul
