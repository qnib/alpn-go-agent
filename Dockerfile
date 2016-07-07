FROM qnib/gocd-base

ENV GO_SERVER=gocd-server \
    GOCD_LOCAL_DOCKERENGINE=false \
    GOCD_CLEAN_IMAGES=false \
    DOCKER_TAG_REV=true \
    GOCD_AGENT_AUTOENABLE_KEY=gocdFTW \
    GOCD_AGENT_AUTOENABLE_ENV=latest,upstream,stack-test,stack \
    GOCD_AGENT_AUTOENABLE_RESOURCES=alpine \
    DOCKER_REPO_DEFAULT=qnib
RUN apk add --update wget git docker jq perl sed bc curl \
 && pip install docker-compose \
 && wget -qO /tmp/go-agent.zip https://download.go.cd/binaries/${GOCD_VER}-${GOCD_SUBVER}/generic/go-agent-${GOCD_VER}-${GOCD_SUBVER}.zip \
 && mkdir -p /opt/ && cd /opt/ \
 && unzip -q /tmp/go-agent.zip && rm -f /tmp/go-agent.zip \
 && mv /opt/go-agent-${GOCD_VER} /opt/go-agent \
 && rm -rf /var/cache/apk/* /tmp/* \
 && chmod +x /opt/go-agent/agent.sh
RUN wget -qO /usr/local/bin/go-github https://github.com/qnib/go-github/releases/download/0.2.2/go-github_0.2.2_Linux \
 && chmod +x /usr/local/bin/go-github
RUN wget -qO /usr/local/bin/go-dckrimg $(/usr/local/bin/go-github rLatestUrl --ghrepo go-dckrimg --regex ".*inux") \
 && chmod +x /usr/local/bin/go-dckrimg
ADD etc/supervisord.d/gocd-agent.ini \
    etc/supervisord.d/docker-engine.ini \
    /etc/supervisord.d/
ADD opt/qnib/gocd/agent/bin/start.sh \
    opt/qnib/gocd/agent/bin/check.sh \
    /opt/qnib/gocd/agent/bin/
ADD opt/go-agent/config/autoregister.properties /opt/go-agent/config/
VOLUME ["/var/lib/docker/"]
ADD etc/consul.d/docker-engine.json \
    etc/consul.d/gocd-agent.json \
    etc/consul.d/
ADD opt/qnib/docker/engine/bin/start.sh /opt/qnib/docker/engine/bin/
ADD opt/qnib/gocd/tasks/docker/build.sh \
    opt/qnib/gocd/tasks/docker/check_img.sh \
    opt/qnib/gocd/tasks/docker/faild_test.sh \
    opt/qnib/gocd/tasks/docker/postbuild.sh \
    opt/qnib/gocd/tasks/docker/prebuild.sh \
    opt/qnib/gocd/tasks/docker/publish.sh \
    opt/qnib/gocd/tasks/docker/test.sh \
    /opt/qnib/gocd/tasks/docker/
ADD opt/qnib/gocd/helpers/gocd-functions.sh /opt/qnib/gocd/helpers/
