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
ADD etc/supervisord.d/gocd-agent.ini /etc/supervisord.d/
ADD opt/qnib/gocd/agent/bin/start.sh /opt/qnib/gocd/agent/bin/
ADD opt/qnib/gocd/helpers/imgcheck/main.go /opt/qnib/gocd/helpers/imgcheck/
RUN apk update && \
    apk add go && \
    cd /opt/qnib/gocd/helpers/imgcheck/ && \
    export GOPATH=/usr/local/ && \
    go get -d && go build && \
    apk del go && \
    rm -rf /var/cache/apk/* /tmp/*

