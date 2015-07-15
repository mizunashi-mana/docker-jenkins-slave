FROM java:latest
MAINTAINER Mizunashi Mana <mizunashi_mana@mma.club.uec.ac.jp>

RUN apt-get update \
 && apt-get install -y openssh-server sudo \
 && rm -rf /var/lib/apt/lists/*

ENV JENKINS_WORKUSER="jenkins" \
    JENKINS_WORKSPACE="/var/jenkins_ws" \
    SETUP_DIR="/var/chche/jenkins"

COPY setup/ ${SETUP_DIR}/
RUN bash ${SETUP_DIR}/install.sh

EXPOSE 22/tcp

VOLUME ["${JENKINS_WORKSPACE}"]
WORKDIR ${JENKINS_WORKSPACE}

CMD ["/usr/sbin/sshd", "-D"]
