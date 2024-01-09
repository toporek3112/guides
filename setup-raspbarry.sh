###################################################
##################### Script ######################
###################################################

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


###################################################
################ Setup Monitoring #################
###################################################

https://prometheus.io/download/
### Prometheus
# Achitecture: armv7

# create directory for service which run directly on the node
mkdir -p .local/services

# copy to pi
scp ~/windows_downloads/prometheus-2.48.1.linux-armv7.tar.gz toporek3112@n01:/home/toporek3112/.local/services
# unzip 
tar -xzvf /home/toporek3112/.local/services/prometheus-2.48.1.linux-armv7.tar.gz
# promehtues.yaml config
vim /home/toporek3112/.local/services/prometheus-2.48.1.linux-armv7/prometheus.yaml

#################### Paste ######################
# my global config
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["localhost:9090"]

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['localhost:9100']
#################################################

# configure to start on startup
sudo vim /etc/systemd/system/prometheus.service

#################### Paste ######################
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=toporek3112
Group=toporek3112
Type=simple
ExecStart=/home/toporek3112/.local/services/prometheus-2.48.1.linux-armv7/prometheus --config.file=/home/toporek3112/.local/services/prometheus-2.48.1.linux-armv7/prometheus.yml --storage.tsdb.path=/home/toporek3112/.local/services/prometheus-2.48.1.linux-armv7/data
Restart=always

[Install]
WantedBy=multi-user.target
#################################################

# reload systemd
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl status prometheus



### Node exporter (for raspbarry [Node] metrics)
# copy to pi
scp ~/windows_downloads/node_exporter-1.7.0.linux-armv7.tar.gz toporek3112@n01:/home/toporek3112/.local/services
# unzip 
tar -xzvf /home/toporek3112/.local/services/node_exporter-1.7.0.linux-armv7.tar.gz

# configure to start on startup
sudo vim /etc/systemd/system/node_exporter.service

#################### Paste ######################
[Unit]
Description=Node-Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=toporek3112
Group=toporek3112
Type=simple
ExecStart=/home/toporek3112/.local/services/node_exporter-1.7.0.linux-armv7/node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
#################################################

# reload systemd
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
sudo systemctl status node_exporter