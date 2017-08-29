FROM corda:m14

# Arguments
ARG path_to_cordapp
ARG node_name

# Copy cordapp jars and confs from local host to container
ADD $path_to_cordapp/kotlin-source/build/nodes/$node_name/corda.jar /opt/corda/corda.jar
ADD $path_to_cordapp/kotlin-source/build/nodes/$node_name/corda-webserver.jar /opt/corda/corda-webserver.jar
ADD $path_to_cordapp/kotlin-source/build/nodes/$node_name/plugins /opt/corda/plugins
ADD ./node-confs/$node_name/node.conf /opt/corda/node.conf

# Create soft-links from /opt/corda dirs and files to service directories
RUN ln -s /opt/corda/plugins /etc/service/corda/plugins \
  && ln -s /opt/corda/node.conf /etc/service/corda/node.conf \
  && ln -s /opt/corda/plugins /etc/service/corda-webserver/plugins \
  && ln -s /opt/corda/node.conf /etc/service/corda-webserver/node.conf \
  && ln -s /etc/service/corda/certificates /etc/service/corda-webserver/certificates

# Port-mapping via docker-compose.yml (more flexible)
# Expose ports for corda
# Default P2P port
#EXPOSE 10002
# Default RPC port
#EXPOSE 10003
# Default web server port
#EXPOSE 10004

# Working directory for Corda
WORKDIR /opt/corda
ENV HOME=/opt/corda

# Start runit
CMD ["/sbin/my_init"]