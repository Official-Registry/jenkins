FROM quay.io/lizhongwen/oracle-jdk:1.8

MAINTAINER github.com/Official-Registry, lizhongwen1989@gmail.com

# environments
ENV JENKINS_SLAVE_AGENT_PORT=50000
# jenkins_home, data directory
ENV JENKINS_WORK=/jenkins
# jenkins programs, jenkins.war, entrypoint.sh
ENV JENKINS_HOME=/opt/app/jenkins
ENV MAVEN_HOME=/opt/app/apache-maven-3.3.9
ENV NODE_HOME=/opt/app/node-v6.7.0-linux-x64
ENV PATH=${PATH}:${MAVEN_HOME}/bin:${NODE_HOME}/bin

ENV JVM_MIN_MEM=512
ENV JVM_MAX_MEM=1024

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME ${JENKINS_WORK}

# Maven local repository
VOLUME /root/.m2

# Define additional metadata for our image.
VOLUME /var/lib/docker

# 8080 for main web interface, 50000 will be used by attached slave agents
EXPOSE 8080 50000

#
# linux tool
#
RUN apt-get update && apt-get install -y git curl zip unzip bzip2 wget expect tar ftp iputils-ping apt-transport-https ca-certificates lxc iptables dmsetup

#
# docker-in-docker
#
RUN curl -sSL https://get.docker.com/ | sh && systemctl enable docker.service

#
# jenkins
#
ADD resources/entrypoint.sh ${JENKINS_HOME}/
RUN mkdir -p /opt/app/jenkins/ \
  && curl --fail --location --retry 3 \
    http://ftp.yz.yamagata-u.ac.jp/pub/misc/jenkins/war/latest/jenkins.war \
    -o /opt/app/jenkins/jenkins.war \
  && chmod +x ${JENKINS_HOME}/entrypoint.sh 

#
# apache-maven
#
RUN curl --fail --location --retry 3 \
    https://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz \
    -o /tmp/maven.tar.gz \
  && tar -zvxf /tmp/maven.tar.gz -C /opt/app/ \
  && rm -f /tmp/maven.tar.gz

#
# node
#
RUN curl --fail --location --retry 3 \
    https://nodejs.org/dist/v6.7.0/node-v6.7.0-linux-x64.tar.gz \
    -o /tmp/node.tar.gz \
  && tar -zvxf /tmp/node.tar.gz -C /opt/app/ \
  && rm -f /tmp/node.tar.gz

ENTRYPOINT ["/bin/sh", "-c", "${JENKINS_HOME}/entrypoint.sh"]
