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