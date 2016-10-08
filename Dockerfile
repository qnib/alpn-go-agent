FROM qnib/alpn-jre8

ENV GO_SERVER=gocd-server \
    GOCD_LOCAL_DOCKERENGINE=false \
    GOCD_CLEAN_IMAGES=false \
    DOCKER_TAG_REV=true \
    GOCD_AGENT_AUTOENABLE_KEY=qnibFTW \
    GOCD_AGENT_AUTOENABLE_ENV=latest,upstream,stack-test,stack \
    GOCD_AGENT_AUTOENABLE_RESOURCES=alpine \
    DOCKER_REPO_DEFAULT=qnib \
    GOPATH=/usr/local/
RUN apk add --no-cache wget git jq perl sed bc curl go linux-vanilla-dev gcc openssl make \
 && go get cmd/vet \
 && apk add 'docker>1.12' --no-cache --repository http://mirror.netcologne.de/alpine/edge/community/ \
 && pip install docker-compose \
 && wget -qO /usr/local/bin/go-github https://github.com/qnib/go-github/releases/download/0.2.2/go-github_0.2.2_MuslLinux \
 && chmod +x /usr/local/bin/go-github \
 && echo "Download '$(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo service-scripts --regex ".*.tar" --limit 1)'" \
 && wget -qO - $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo service-scripts --regex ".*.tar" --limit 1) |tar xf - -C /opt/ \
 && wget -qO /usr/local/bin/go-dckrimg $(/usr/local/bin/go-github rLatestUrl --ghrepo go-dckrimg --regex ".*inux") \
 && chmod +x /usr/local/bin/go-dckrimg \
 && rm -f /usr/local/bin/go-github \
 && rm -rf /var/cache/apk/* /tmp/* /usr/local/bin/go-github /opt/go-agent/config/autoregister.properties \
 && . /opt/service-scripts/gocd/common/version \
 && wget -qO /tmp/go-agent.zip https://download.go.cd/binaries/${GOCD_VER}-${GOCD_SUBVER}/generic/go-agent-${GOCD_VER}-${GOCD_SUBVER}.zip \
 && mkdir -p /opt/ && cd /opt/ \
 && unzip -q /tmp/go-agent.zip && rm -f /tmp/go-agent.zip \
 && mv /opt/go-agent-${GOCD_VER} /opt/go-agent
RUN chmod +x /opt/go-agent/agent.sh
ADD etc/supervisord.d/gocd-agent.ini \
    etc/supervisord.d/docker-engine.ini \
    /etc/supervisord.d/
VOLUME ["/var/lib/docker/"]
ADD etc/consul.d/docker-engine.json \
    etc/consul.d/gocd-agent.json \
    etc/consul.d/
ADD opt/qnib/docker/engine/bin/start.sh /opt/qnib/docker/engine/bin/
ADD etc/consul-templates/gocd/autoregister.properties.ctmpl /etc/consul-templates/gocd/
