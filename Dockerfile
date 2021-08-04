# This Dockerfile is used to build an image capable of running the npm keytar node module
# It must be given the capability of IPC_LOCK or be run in privilaged mode to properly operate
FROM awharn/jenkins-nvm-keytar

USER root

ENV DEFAULT_NODE_VERSION=16.6.1
ARG scriptsDir=/usr/local/bin/
COPY docker-entrypoint-zowe.sh ${scriptsDir}
COPY install_zowe.sh ${scriptsDir}

# Install next by default
# Not everything has a next version
RUN install_node.sh ${DEFAULT_NODE_VERSION}
RUN su -c "install_node.sh ${DEFAULT_NODE_VERSION}" - jenkins
RUN su -c "install_zowe.sh next true" - jenkins 

ENTRYPOINT ["docker-entrypoint-zowe.sh"]

# Exec ssh
CMD ["/usr/sbin/sshd", "-D"]
