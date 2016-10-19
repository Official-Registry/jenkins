# Jenkins Docker image    
  
The Jenkins Continuous Integration and Delivery server.
  
This is a fully functional Jenkins server, based on the Long Term Support release
[http://jenkins-ci.org/](http://jenkins-ci.org/).
  
<img src="http://jenkins-ci.org/sites/default/files/jenkins_logo.png"/>
  
# Usage
    
`docker run -p 8080:8080 -p 50000:50000 --privileged quay.io/lizhongwen/jenkins`  
  
NOTE: read below the _build executors_ part for the role of the `50000` port mapping. --privileged for docker-in-docker.

This will store the workspace in /jenkins. All Jenkins data lives in there - including plugins and configuration.
You will probably want to make that a persistent volume (recommended):
  
  
`docker run -d --restart always -p 8080:8080 -p 50000:50000 --privileged -v /your/home:/jenkins quay.io/lizhongwen/jenkins`
  
  
This will store the jenkins data in `/your/home` on the host.
Ensure that `/your/home` is accessible by the jenkins user in container (jenkins user - root) or use `-u some_other_user` parameter with `docker run`.  
  
  
`docker run --privileged --restart always -d -p 8080:8080 -p 50000:50000 -v /some/dir:/jenkins --add-host=euler-registry.primeton.com:10.15.15.172 -e JVM_MIN_MEM=1024 -e JVM_MAX_MEM=2048 quay.io/lizhongwen/jenkins`
  
  
Add insecure docker registry configuration  
  
  
`# Generate ubuntu docker configuration file`  
`echo "DOCKER_OPTS=\"--insecure-registry euler-registry.primeton.com\"" > /some/dir/docker`  
`# Run jenkins image`
`docker run --privileged --restart always -d -p 8080:8080 -p 50000:50000 -v /some/dir/docker:/etc/default/docker -v /some/dir:/jenkins --add-host=euler-registry.primeton.com:10.15.15.172 -e JVM_MIN_MEM=1024 -e JVM_MAX_MEM=2048 quay.io/lizhongwen/jenkins`
  
  
# VOLUME  
  
`/jenkins`  
`/root/.m2`  
`/var/lib/docker`
  
  
# Environment  
  
`echo "JAVA_HOME=${JAVA_HOME}"`  
`echo "NODE_HOME=${NODE_HOME}"`  
`echo "MAVEN_HOME=${MAVEN_HOME}"`  
`echo "JENKINS_HOME=${JENKINS_HOME}"`  
`echo "JENKINS_WORK=${JENKINS_WORK}"`  

