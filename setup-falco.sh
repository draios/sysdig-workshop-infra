#!/bin/bash
sudo echo 'export PS1="\[\e[36m\]falco\[\e[m\]:\[\e[32m\]\W\[\e[m\] \n\[\e[35m\]\\$\[\e[m\] "
' > /home/falco/.bash_profile

git clone https://github.com/draios/sysdig-workshop-troubleshooting/
git clone https://github.com/draios/sysdig-workshop-forensics/
git clone https://github.com/falcosecurity/falco
git clone https://github.com/falcosecurity/kubernetes-response-engine
git clone https://github.com/falcosecurity/falco-security-workshop

curl -s https://s3.amazonaws.com/download.draios.com/stable/install-sysdig  | sudo bash

# sudo pip install virtualenvwrapper

# git clone https://github.com/yyuu/pyenv.git /home/falco/.pyenv
# git clone https://github.com/yyuu/pyenv-virtualenvwrapper.git /home/falco/.pyenv/plugins/pyenv-virtualenvwrapper

# echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /home/falco/.bashrc
# echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /home/falco/.bashrc
# echo 'eval "$(pyenv init -)"' >> /home/falco/.bashrc

sudo pip install pipenv

curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubectl
chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube

sudo cp minikube /usr/local/bin && rm minikube


curl -LO https://storage.googleapis.com/kubernetes-helm/helm-v2.13.0-linux-amd64.tar.gz
tar -zxvf helm-v2.13.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
sudo rm -fr linux-amd64

export RELEASE=$(curl -s https://api.github.com/repos/kubeless/kubeless/releases/latest | grep tag_name | cut -d '"' -f 4)
export OS=$(uname -s| tr '[:upper:]' '[:lower:]')
curl -OL https://github.com/kubeless/kubeless/releases/download/$RELEASE/kubeless_$OS-amd64.zip && \
  unzip kubeless_$OS-amd64.zip && \
  sudo mv bundles/kubeless_$OS-amd64/kubeless /usr/local/bin/ &&
  rm -fr bundles

echo 'export MINIKUBE_WANTUPDATENOTIFICATION=false'  >> /home/falco/.bashrc
echo 'export MINIKUBE_WANTREPORTERRORPROMPT=false'  >> /home/falco/.bashrc
echo 'export MINIKUBE_HOME=$HOME'  >> /home/falco/.bashrc
echo 'export CHANGE_MINIKUBE_NONE_USER=true'  >> /home/falco/.bashrc
export KUBECONFIG=$HOME/.kube/config
echo 'export KUBECONFIG=$HOME/.kube/config'  >> /home/falco/.bashrc

mkdir -p $HOME/.kube $HOME/.minikube
touch $KUBECONFIG

kubectl completion bash > /tmp/kubectl
sudo mv /tmp/kubectl /etc/bash_completion.d/

helm completion bash > /tmp/helm
sudo mv /tmp/helm /etc/bash_completion.d/
