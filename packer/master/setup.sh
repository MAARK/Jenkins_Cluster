#!/bin/bash

echo "Install Jenkins LTS"
yum update -y
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install -y fontconfig java-11-amazon-corretto-devel jenkins
chkconfig jenkins on

echo "Install git"
sudo yum install -y git locate tmux tree screen make

echo "Install hashicorp repo"
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/$release/hashicorp.repo

echo "Install terraform and terragrunt"
sudo yum install -y terraform terragrunt

echo "Setup SSH key"
mkdir /var/lib/jenkins/.ssh
touch /var/lib/jenkins/.ssh/known_hosts
chown -R jenkins:jenkins /var/lib/jenkins/.ssh
chmod 700 /var/lib/jenkins/.ssh
mv /tmp/id_rsa /var/lib/jenkins/.ssh/id_rsa
chmod 600 /var/lib/jenkins/.ssh/id_rsa
chown -R jenkins:jenkins /var/lib/jenkins/.ssh/id_rsa

echo "Configure Jenkins"
mkdir -p /var/lib/jenkins/init.groovy.d
mv /tmp/scripts/*.groovy /var/lib/jenkins/init.groovy.d/
chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d
mv /tmp/config/jenkins /etc/sysconfig/jenkins
chmod +x /tmp/config/install-plugins.sh
mkdir -p /var/lib/jenkins/plugins
chown -R jenkins:jenkins /var/lib/jenkins/plugins
bash /tmp/config/install-plugins.sh
systemctl jenkins start

echo "install tgenv"
git clone https://github.com/cunymatthieu/tgenv.git ~/.tgenv
cd ~/.tgenv
tgenv install latest
