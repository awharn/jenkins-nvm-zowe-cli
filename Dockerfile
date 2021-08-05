# This Dockerfile is used to build an image capable of running the npm keytar node module
# It must be given the capability of IPC_LOCK or be run in privilaged mode to properly operate
FROM awharn/jenkins-nvm-keytar

USER root

ENV DEFAULT_NODE_VERSION=16.6.1
ENV ZOWE_APP_LOG_LEVEL=ERROR
ENV ZOWE_IMPERATIVE_LOG_LEVEL=ERROR
ARG scriptsDir=/usr/local/bin/
COPY docker-entrypoint-zowe.sh ${scriptsDir}
COPY install_zowe.sh ${scriptsDir}

# Setup Zowe Daemon
RUN wget https://github.com/zowe/zowe-cli/releases/download/native-v0.2.1/zowex-linux.tgz
RUN tar -xzf zowex-linux.tgz
RUN rm -rf zowex-linux.tgz
RUN chmod +rx zowex
RUN mv zowex ${scriptsDir}

# Quick script to start daemon
COPY start-zowe-daemon ${scriptsDir}
COPY start-zowe-daemon-2 ${scriptsDir}
COPY bashrc-update.txt ${scriptsDir}
RUN cat ${scriptsDir}bashrc-update.txt >> /etc/bash.bashrc
RUN cat ${scriptsDir}bashrc-update.txt >> /home/jenkins/.bashrc
RUN rm ${scriptsDir}bashrc-update.txt

# Install next by default
# Not everything has a next version
RUN install_node.sh ${DEFAULT_NODE_VERSION}
RUN su -c "install_node.sh ${DEFAULT_NODE_VERSION}" - jenkins
RUN su -c "install_zowe.sh next true" - jenkins 

ENTRYPOINT ["docker-entrypoint-zowe.sh"]

# Exec ssh
CMD ["/usr/sbin/sshd", "-D"]
