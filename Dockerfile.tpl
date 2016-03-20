FROM %DOCKER_REGISTRY%docker-library-jre8

MAINTAINER Serge Fomin <serge.fo@gmail.com>

ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_MANAGER_PORT 8080
ENV JENKINS_SLAVE_AGENT_PORT 50000
ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

ENV JENKINS_UC https://updates.jenkins-ci.org

EXPOSE $JENKINS_MANAGER_PORT
EXPOSE $JENKINS_SLAVE_AGENT_PORT

RUN apk update \
  && apk add bash \
  && rm -rf \
    /tmp/* \
    /var/cache/apk/*

COPY plugins.sh /bin/plugins.sh
RUN chmod +x /bin/plugins.sh

COPY jenkins.sh /bin/jenkins.sh
RUN chmod +x /bin/jenkins.sh

ADD https://github.com/krallin/tini/releases/download/v0.9.0/tini-static /bin/tini
RUN chmod +x /bin/tini

RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d \
  && mkdir -p $JENKINS_HOME \
  && touch $COPY_REFERENCE_FILE_LOG

ADD http://mirrors.jenkins-ci.org/war/latest/jenkins.war /usr/share/jenkins/jenkins.war
COPY init.groovy.d /usr/share/jenkins/ref/init.groovy.d

CMD /bin/tini -s -- /bin/jenkins.sh
