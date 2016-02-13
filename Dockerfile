FROM qnib/alpn-jre7

ENV GOCD_VER=16.1.0 \
    GOCD_SUBVER=2855 \
    GO_SERVER=gocd-server.node.consul
RUN apk update && \
    apk add wget git docker && \
    wget -qO /tmp/go-agent.zip https://download.go.cd/binaries/${GOCD_VER}-${GOCD_SUBVER}/generic/go-agent-${GOCD_VER}-${GOCD_SUBVER}.zip && \
    mkdir -p /opt/ && cd /opt/ && \
    unzip -q /tmp/go-agent.zip && rm -f /tmp/go-agent.zip && \
    mv /opt/go-agent-${GOCD_VER} /opt/go-agent && \
    rm -rf /var/cache/apk/* /tmp/* && \
    chmod +x /opt/go-agent/agent.sh
ADD etc/supervisord.d/gocd-agent.ini \
    etc/supervisord.d/docker-engine.ini \
    /etc/supervisord.d/
ADD opt/qnib/gocd/agent/bin/start.sh /opt/qnib/gocd/agent/bin/
ADD opt/qnib/gocd/helpers/imgcheck/main.go /opt/qnib/gocd/helpers/imgcheck/
RUN apk update && \
    apk add go && \
    cd /opt/qnib/gocd/helpers/imgcheck/ && \
    export GOPATH=/usr/local/ && \
    go get -d && go build && \
    apk del go && \
    rm -rf /var/cache/apk/* /tmp/*
ADD opt/go-agent/config/autoregister.properties /opt/go-agent/config/
RUN wget -qO /usr/local/bin/go-github https://github.com/qnib/go-github/releases/download/0.2.2/go-github_0.2.2_Linux && \
    chmod +x /usr/local/bin/go-github
VOLUME ["/var/lib/docker/"]
ADD etc/consul.d/docker-engine.json \
    etc/consul.d/
ADD opt/qnib/docker/engine/bin/start.sh /opt/qnib/docker/engine/bin/
