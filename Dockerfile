# This Dockerfile is used to build an image capable of running the npm keytar node module
# It must be given the capability of IPC_LOCK or be run in privilaged mode to properly operate
FROM awharn/jenkins-nvm-keytar

USER root

ARG scriptsDir=/usr/local/bin/
COPY docker-entrypoint-zowe.sh ${scriptsDir}
COPY install_zowe.sh ${scriptsDir}

# Quick script to start daemon
COPY start-zowe-daemon ${scriptsDir}
COPY start-zowe-daemon-2 ${scriptsDir}
COPY bashrc-update.txt ${scriptsDir}
RUN cat ${scriptsDir}bashrc-update.txt >> /etc/bash.bashrc
RUN cat ${scriptsDir}bashrc-update.txt >> /home/jenkins/.bashrc
RUN rm ${scriptsDir}bashrc-update.txt

RUN su -c "install_zowe.sh zowe-v2-lts true" - jenkins

ENTRYPOINT ["docker-entrypoint-zowe.sh"]

# Exec ssh
CMD ["/usr/sbin/sshd", "-D"]
