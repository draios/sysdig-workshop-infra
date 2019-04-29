#!/bin/bash
sudo echo 'export PS1="\[\e[36m\]sysdig\[\e[m\]:\[\e[32m\]\W\[\e[m\] \n\[\e[35m\]\\$\[\e[m\] "
' > /home/sysdig/.bash_profile

git clone https://github.com/draios/sysdig-workshop-troubleshooting/
git clone https://github.com/draios/sysdig-workshop-forensics/

curl -s https://s3.amazonaws.com/download.draios.com/stable/install-sysdig  | sudo bash
