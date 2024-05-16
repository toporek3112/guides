#!/bin/bash

# Get the current logged-in user
CURRENT_USER=$(whoami)
export BASHRC="/home/$CURRENT_USER/.bashrc"
LOCAL_BIN="/home/$CURRENT_USER/.local/bin"

# Ensure ~/.local/bin exists and is in PATH
mkdir -p $LOCAL_BIN
if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
  echo "export PATH=\$PATH:$LOCAL_BIN" >> $BASHRC
  export PATH=$PATH:$LOCAL_BIN
fi

# Installing kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl $LOCAL_BIN/kubectl

# Installing helm
echo "Installing helm..."
curl -LO https://get.helm.sh/helm-v3.11.3-linux-amd64.tar.gz
tar -zxvf helm-v3.11.3-linux-amd64.tar.gz
chmod +x linux-amd64/helm
mv linux-amd64/helm $LOCAL_BIN/helm
rm -rf linux-amd64 helm-v3.11.3-linux-amd64.tar.gz

# Adding aliases to .bashrc
echo "Adding aliases to .bashrc..."

echo "" >> $BASHRC
echo "alias l='ls -lh'" >> $BASHRC
echo "alias ll='ls -lha'" >> $BASHRC
echo "alias k='kubectl'" >> $BASHRC
echo "alias compose='docker-compose'" >> $BASHRC
echo "alias composer='docker-compose down && docker-compose up -d'" >> $BASHRC
echo "alias dockeri='docker images'" >> $BASHRC
echo "alias dockerir='docker image rm'" >> $BASHRC
echo "alias dockerp='docker ps'" >> $BASHRC
echo "alias dockerpa='docker ps -a'" >> $BASHRC
echo "alias dockzap='f() { docker stop \$1 && docker rm \$1; }; f'" >> $BASHRC
echo "alias dockerdebug='docker run -it --rm --network host debug-tools'" >> $BASHRC

# Reload .bashrc
source $BASHRC
unset BASHRC

echo "Script completed. Please restart your terminal or source your .bashrc to apply the changes."
