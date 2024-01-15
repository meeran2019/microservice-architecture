#!/bin/bash
kubectl version --client
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.5/2024-01-04/bin/linux/amd64/kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.5/2024-01-04/bin/linux/amd64/kubectl.sha256
sha256sum -c kubectl.sha256
openssl sha1 -sha256 kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
kubectl version --client

aws eks update-kubeconfig --region us-east-1 --name eks-cluster
aws configure set aws_access_key_id ${access_key}
aws configure set aws_secret_access_key ${secret_key}
aws configure set default.region us-east-1
aws configure set default.output json

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# install in default namespace
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd

#install newrelic, v2.10.0
helm repo add newrelic https://helm-charts.newrelic.com && helm repo update && \
kubectl create namespace newrelic ; helm upgrade --install newrelic-bundle newrelic/nri-bundle \
 --set global.licenseKey=83b2aFFFFNRAL \
 --set global.cluster=eks-cluster \
 --namespace=newrelic \
 --set newrelic-infrastructure.privileged=true \
 --set global.lowDataMode=true \
 --set kube-state-metrics.image.tag=${KSM_IMAGE_VERSION} \
 --set kube-state-metrics.enabled=true \
 --set kubeEvents.enabled=true \
 --set newrelic-prometheus-agent.enabled=true \
 --set newrelic-prometheus-agent.lowDataMode=true \
 --set newrelic-prometheus-agent.config.kubernetes.integrations_filter.enabled=false \
 --set newrelic-pixie.enabled=true \
 --set newrelic-pixie.apiKey=px-api--20293140d448 \
 --set pixie-chart.enabled=true \
 --set pixie-chart.deployKey=px-dep-18d80 \
 --set pixie-chart.clusterName=eks-cluster \
 --set newrelic-k8s-metrics-adapter.config.externalMetrics.manipulate_average_requests.query='FROM Metric SELECT average(http.server.duration) WHERE instrumentation.provider='pixie''

sudo yum update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo dnf install java-17-amazon-corretto -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins