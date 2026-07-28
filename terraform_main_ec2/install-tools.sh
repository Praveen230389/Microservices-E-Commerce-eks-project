#!/bin/bash

# Update system packages
sudo yum update -y
git --version

# Install essential tools
sudo yum install -y git wget unzip curl yum-utils

# Install Java (required for Jenkins)
sudo dnf install -y java-21-amazon-corretto
java -version

# Install npm
sudo dnf install nodejs -y
node -v
npm -v


# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
#systemctl status jenkins

# Install Terraform
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install -y terraform
terraform -v

# Install Maven
sudo yum install -y maven
mvn -v

# Install ansible
sudo yum install -y ansible
ansible --version

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin/
eksctl version

# Install Helm
wget https://get.helm.sh/helm-v3.6.0-linux-amd64.tar.gz
tar -zxvf helm-v3.6.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
chmod +x /usr/local/bin/helm
rm -rf helm-v3.6.0-linux-amd64.tar.gz linux-amd64
helm version

# Install Docker
sudo yum install -y docker
sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins
sudo systemctl enable docker
sudo systemctl start docker
sudo docker --version  

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo docker-compose --version

# Install Trivy
sudo tee /etc/yum.repos.d/trivy.repo <<EOF
[trivy]
name=Trivy repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
EOF

sudo dnf install -y trivy

trivy --version

# Install vault
sudo yum install -y vault




# Install MariaDB
sudo yum install -y mariadb105-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
mysql --version 
#systemctl status mariadb


# Install PostgreSQL 
sudo dnf install -y postgresql15-server

sudo /usr/bin/postgresql-setup --initdb

sudo systemctl enable postgresql

sudo systemctl start postgresql

systemctl status postgresql

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

echo "✅ Initialization script completed successfully."

# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get pods -n argocd

# Install Prometheus and Grafana using Helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace prometheus
helm install prometheus prometheus-community/kube-prometheus-stack -n prometheus
kubectl get pods -n prometheus
