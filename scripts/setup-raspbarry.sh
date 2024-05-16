#!/bin/bash

export BASHRC="/home/toporek3112/.bashrc"

# Ensuring the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Updating and upgrading the system
echo "Updating and upgrading the system..."
sudo apt-get update && sudo apt-get upgrade -y

# Installing Vim
echo "Installing Vim..."
sudo apt-get install vim -y

echo "Adding user for docker containers to use..."
sudo useradd -u 3112 docker_container

# Adding aliases to .bashrc
echo "Adding aliases to .bashrc..."

echo "" >> $BASHRC

# Checking if aliases already exist
# l
echo "alias l='ls -lh'" >> $BASHRC
echo "alias ll='ls -lha'" >> $BASHRC
echo "alias k='kubectl'" >> $BASHRC
echo "alias compose='docker-compose'" >> $BASHRC
echo "alias composer='docker-compose down && docker-compose up -d'" >> $BASHRC
echo "alias dockeri='docker images'" >> $BASHRC
echo "alias dockerir='docker image rm'" >> $BASHRC
echo "alias dockerp='docker ps'" >> $BASHRC
echo "alias dockerpa='docker ps -a'" >> $BASHRC
echo "alias dockzap='f() { docker stop $1 && docker rm $1; }; f'" >> $BASHRC
echo "alias dockerdebug='docker run -it --rm --network host debug-tools'" >> $BASHRC

# Install required packages for Docker
echo "Installing required packages for Docker..."
sudo apt-get install apt-transport-https ca-certificates software-properties-common -y

# Add Docker’s official GPG key
echo "Adding Docker's official GPG key..."
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the Docker repository
echo "Setting up the Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
echo "Installing Docker..."
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Add current user to the Docker group
echo "Adding user to the Docker group..."
sudo usermod -aG docker $USER

# Install NVM, Node.js, and npm
echo "Installing NVM, Node.js, and npm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install node

# Install Miniconda for ARM
echo "Installing Miniconda for ARM..."
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-aarch64.sh
bash Miniforge3-Linux-aarch64.sh -b -p $HOME/miniforge3
echo 'export PATH="$HOME/miniforge3/bin:$PATH"' >> $BASHRC
source $HOME/miniforge3/bin/activate
conda init

# Reload .bashrc
source $BASHRC
unset BASHRC

echo "Script completed. Please restart your terminal or source your .bashrc to apply the changes."
