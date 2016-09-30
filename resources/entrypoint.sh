#!/bin/bash

#
# Copyright (c) 1989-2016 Private Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizhongwen1989@gmail.com)
#

if [ -z "${JENKINS_WORK}" ]; then
    JENKINS_WORK="/jenkins"
fi

if [ -z "${JVM_MIN_MEM}" ]; then
  JVM_MIN_MEM=512
fi
if [ -z "${JVM_MAX_MEM}" ]; then
  JVM_MAX_MEM=1024
fi

JAVA_OPTS="${JAVA_OPTS} -Xms${JVM_MIN_MEM}m -Xmx${JVM_MAX_MEM}m"
JAVA_OPTS="${JAVA_OPTS} -Dfile.encoding=utf-8 -Duser.timezone=Asia/Shanghai"

#
# Jenkins workspace setting
#
JAVA_OPTS="${JAVA_OPTS} -DJENKINS_HOME=${JENKINS_WORK}"

if [ ! -f ${JENKINS_HOME}/jenkins.war ]; then
    echo "${JENKINS_HOME}/jenkins.war not found."
    exit 1
fi

service docker start

${JAVA_HOME}/bin/java ${JAVA_OPTS} -jar ${JENKINS_HOME}/jenkins.war

