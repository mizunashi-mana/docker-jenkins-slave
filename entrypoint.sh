#!/bin/bash
set -e

sudo -HEu ${JENKINS_WORKUSER} mkdir -p ${JENKINS_WORKSPACE}/.ssh/

if [ -z "${AUTHORIZED_KEYS_TOKEN}" || "${AUTHORIZED_KEYS_URL}" ]
then
    curl "${AUTHORIZED_KEYS_URL}" > ${JENKINS_WORKSPACE}/.ssh/authorized_keys
else
    if [ ! -f ${JENKINS_WORKSPACE}/.ssh/authorized_keys ]; then
        cp ${SETUP_DIR}/authorized_keys ${JENKINS_WORKSPACE}/.ssh/authorized_keys
    fi
fi

chmod 700 ${JENKINS_WORKSPACE}/.ssh
chmod 600 ${JENKINS_WORKSPACE}/.ssh/authorized_keys
chown -R ${JENKINS_WORKUSER}:${JENKINS_WORKUSER} ${JENKINS_WORKSPACE}/.ssh

set -x
exec start_stop_daemon --start --chuid ${JENKINS_WORKUSER}:${JENKINS_WORKUSER} \
  --exec /user/sbin/sshd -- -D
