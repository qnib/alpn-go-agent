FROM qnib/alpn-jre7

ENV GOCD_VER=16.1.0 \
    GOCD_SUBVER=2855
RUN apk update && \
    apk add wget && \
    wget -qO /tmp/go-agent.zip https://download.go.cd/binaries/${GOCD_VER}-${GOCD_SUBVER}/generic/go-agent-${GOCD_VER}-${GOCD_SUBVER}.zip && \
    mkdir -p /opt/ && cd /opt/ && \
    unzip -q /tmp/go-agent.zip && rm -f /tmp/go-agent.zip && \
    mv /opt/go-agent-${GOCD_VER} /opt/go-agent && \
    rm -rf /var/cache/apk/* /tmp/*
#ADD etc/consul.d/go-server.json /etc/consul.d/
#ADD etc/init.d/go-server /etc/init.d/


