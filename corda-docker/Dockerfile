# Base image from (http://phusion.github.io/baseimage-docker)
FROM phusion/baseimage:0.9.22

# Set up Version
ENV version=0.14.0

# Set image labels
LABEL net.corda.version=${version}

# Install OpenJDK from zulu.org and update system
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0x219BD9C9 \
# && (echo "deb http://repos.azulsystems.com/ubuntu stable main" >> /etc/apt/sources.list.d/zulu.list)
#RUN apt-get -qq update \
# && apt-get -y upgrade
#RUN apt-get -qqy install zulu-8 ntp

# Install Oracle-Java8 from webupd8team
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
  && add-apt-repository -y ppa:webupd8team/java \
  && apt-get -qq update \
  && apt-get -y upgrade \
  && apt-get install -qqy oracle-java8-installer ntp \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /var/cache/oracle-jdk8-installer

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Create directories
RUN mkdir -p /opt/corda/logs \
  && mkdir -p /opt/corda-webserver/logs \
  && mkdir -p /etc/service/corda/certificates \
  && mkdir /etc/service/corda-webserver

# Copy corda jar
#ADD https://dl.bintray.com/r3/corda/net/corda/corda/$version/corda-$version.jar /opt/corda/corda.jar

### Init script for corda
COPY corda-$version.sh /etc/service/corda/run
RUN chmod +x /etc/service/corda/run

### Init script for corda-webserver
COPY corda-webserver-$version.sh /etc/service/corda-webserver/run
RUN chmod +x /etc/service/corda-webserver/run

### Wait script for non-controller nodes
COPY wait_for_controller.sh /opt/corda/wait_for_controller.sh
RUN chmod +x /opt/corda/wait_for_controller.sh

# Working directory for Corda
WORKDIR /opt/corda
ENV HOME=/opt/corda

# Start runit
CMD ["/sbin/my_init"]