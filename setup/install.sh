#!/bin/bash
set -e

useradd -d "${JENKINS_WORKSPACE}" -u 1000 -m -s /bin/bash ${JENKINS_WORKUSER}
echo "${JENKINS_WORKUSER}:jenkins" | chpasswd

rm -rf ${JENKINS_WORKSPACE}/.ssh
sudo -HEu ${JENKINS_WORKUSER} mkdir -p ${JENKINS_WORKSPACE}/.ssh

sed 's/UsePAM yes/UsePAM no/' -i /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config

sed 's/#PasswordAuthentication yes/PasswordAuthentication no/' -i /etc/ssh/sshd_config

sed 's/LogLevel INFO/LogLevel VERBOSE/' -i /etc/ssh/sshd_config

mkdir -p /var/run/sshd

