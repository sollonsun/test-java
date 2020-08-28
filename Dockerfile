FROM centos

ADD entrypoint.sh /root
ADD jdk /usr/local/jdk/

RUN yum install -y wget
RUN yum install -y git
RUN wget https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
RUN tar -zxvf apache-maven-3.6.3-bin.tar.gz
RUN mv apache-maven-3.6.3 /usr/local


ENV JAVA_HOME=/usr/jdk/
ENV MAVEN_HOME=/usr/apache-maven-3.6.3
ENV PATH=$PATH:$MAVEN_HOME/bin:$JAVA_HOME/bin

ENTRYPOINT ["/bin/bash","/root/entrypoint.sh"]
