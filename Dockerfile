# This Dockerfile is used to build an image capable of running the npm keytar node module
# It must be given the capability of IPC_LOCK or be run in privilaged mode to properly operate
FROM awharn/jenkins-nvm-keytar

USER root

ARG scriptsDir=/usr/local/bin/
COPY docker-entrypoint-zowe.sh ${scriptsDir}
COPY install_zowe.sh ${scriptsDir}

# Install zowe-v1-lts by default
RUN su -c "install_zowe.sh zowe-v1-lts" - jenkins 

ENTRYPOINT ["docker-entrypoint-zowe.sh"]

# Exec ssh
CMD ["/usr/sbin/sshd", "-D"]
