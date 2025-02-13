#!/bin/bash
set -e
# Update and install Java
yum update -y

# Install Jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum upgrade -y
dnf install java-17-amazon-corretto-headless -y
yum install git unzip jenkins -y

# Install Terraform
TERRAFORM_VERSION="1.5.7"
curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/

# Start Jenkins service
systemctl enable jenkins
systemctl start jenkins

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -qq awscliv2.zip
sudo ./aws/install

# Clean up installation files
rm -rf awscliv2.zip aws/
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

