# Based on https://github.com/corda/corda-docker

# Base image from (http://phusion.github.io/baseimage-docker)
FROM phusion/baseimage:0.9.22

# Set up Version
ENV version=0.14.0

# Set image labels
LABEL net.corda.version=${version}

# Install OpenJDK from zulu.org and update system
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0x219BD9C9 \
 && (echo "deb http://repos.azulsystems.com/ubuntu stable main" >> /etc/apt/sources.list.d/zulu.list)
RUN apt-get -qq update \
 && apt-get -y upgrade
RUN apt-get -qqy install zulu-8 ntp

# Cleanup
RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create directories
RUN mkdir -p /opt/corda/logs \
  && mkdir -p /opt/corda-webserver/logs \
  && mkdir -p /etc/service/corda/certificates \
  && mkdir /etc/service/corda-webserver

### Init script for corda
COPY corda-$version.sh /etc/service/corda/run
RUN chmod +x /etc/service/corda/run

### Init script for corda-webserver
COPY corda-webserver-$version.sh /etc/service/corda-webserver/run
RUN chmod +x /etc/service/corda-webserver/run

### Wait script for nodes
COPY wait_for_controller.sh /opt/corda/wait_for_controller.sh
RUN chmod +x /opt/corda/wait_for_controller.sh