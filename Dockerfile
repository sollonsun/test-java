FROM justrydeng/jdk8
MAINTAINER dengshuai<13548417409@163.com>
RUN mkdir /var/jarDir && mkdir /var/jarDir/jenkins-docker-test
CMD ["nohup","java","-jar","/var/jarDir/jenkins-docker-test/jenkins-0.0.1-SNAPSHOT.jar","&"]
