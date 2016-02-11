FROM qnib/alpn-jre7

ENV GOCD_VER=16.1.0-2855
RUN apk update && \
    apk add wget && \
    wget -qO /tmp/go-agent.zip https://download.go.cd/binaries/${GOCD_VER}/generic/go-agent-${GOCD_VER}.zip && \
    mkdir -p /opt/ && cd /opt/ && \
    unzip -q /tmp/go-agent.zip && rm -f /tmp/go-agent.zip 
#ADD etc/consul.d/go-server.json /etc/consul.d/
#ADD etc/init.d/go-server /etc/init.d/


