#!/bin/bash
set -e

sudo -HEu ${JENKINS_WORKUSER} mkdir -p ${JENKINS_WORKSPACE}/.ssh/

if [ -n "${AUTHORIZED_KEY_STRING}" ] 
then
    echo "${AUTHORIZED_KEY_STRING}" > ${JENKINS_WORKSPACE}/.ssh/authorized_keys
else
    if [ -n "${AUTHORIZED_KEYS_URL}" ]
    then
        wget "${AUTHORIZED_KEYS_URL}" -O ${JENKINS_WORKSPACE}/.ssh/authorized_keys \
          || (echo "Illegal url : ${AUTHORIZED_KEYS_URL}. Please check and retry." \
          && exit 1)
    else
        if [ ! -f ${JENKINS_WORKSPACE}/.ssh/authorized_keys ]; then
            echo "Use default example key. It is very dangerous!! You must be change key."
            cp ${SETUP_DIR}/authorized_keys ${JENKINS_WORKSPACE}/.ssh/authorized_keys
        fi
    fi
fi

chmod 700 ${JENKINS_WORKSPACE}/.ssh
chmod 600 ${JENKINS_WORKSPACE}/.ssh/authorized_keys
chown -R ${JENKINS_WORKUSER}:${JENKINS_WORKUSER} ${JENKINS_WORKSPACE}/.ssh

[ -f "/etc/ssh/ssh_host_rsa_key" ] || ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N ''
[ -f "/etc/ssh/ssh_host_dsa_key" ] || ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -C '' -N ''
[ -f "/etc/ssh/ssh_host_ecdsa_key" ] || ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -C '' -N ''
[ -f "/etc/ssh/ssh_host_ed25519_key" ] || ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -C '' -N ''

echo "Printing fingerprint of authorized keys..."
ssh-keygen -lf ${JENKINS_WORKSPACE}/.ssh/authorized_keys
echo

echo "Printing each fingerprint of host keys..."
ssh-keygen -lf /etc/ssh/ssh_host_rsa_key.pub
ssh-keygen -lf /etc/ssh/ssh_host_dsa_key.pub
ssh-keygen -lf /etc/ssh/ssh_host_ecdsa_key.pub
ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub
echo

set -x
exec start-stop-daemon --start \
  --exec /usr/sbin/sshd -- -D
