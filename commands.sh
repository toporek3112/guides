#################################################
################### Docker ######################
#################################################

# docker proxy settings directory:
# /etc/default/docker

# troubleshooting container
docker build -t debug-tools -f dockerfile_troubleshoot .
docker tag debug-tools:latest 311200/debug-tools:latest
docker push 311200/debug-tools:latest

docker run -it --rm --network host 311200/debug-tools

# conda image
docker build -t my_conda:latest -f dockerfile_conda .
docker tag my_conda:latest 311200/my_conda:latest
docker push 311200/my_conda:latest

# remove all "dangling" images
## This command removes all dangling images, 
## which are images not tagged and not referenced by any container
docker rmi $(docker images -f "dangling=true" -q)

# redirect stderr to stdout
docker logs loki -f > delete_me.log 2>&1

#################################################
################### Postgres ####################
#################################################

psql -h dsi_postgres -p 5432 -U postgres -d postgres

#################################################
#################### Kafka ######################
#################################################

# consume from topic
bin/kafka-console-consumer.sh --bootstrap-server kafka_00:9094 --topic topic_interruptions --from-beginning
# delete a topic
bin/kafka-topics.sh --bootstrap-server kafka_00:9094 --delete --topic stocks_topic
# list topics
bin/kafka-topics.sh --bootstrap-server kafka_00:9094 --list
# create topic
bin/kafka-topics.sh --bootstrap-server kafka_00:9094 --create --if-not-exists --replication-factor 1 --partitions 1 --config cleanup.policy=compact --topic stocks_topic
# produce json event
echo '{"id": "137232", "title": "U-Bahnbau\nZüge halten bei Josefstädter Str. 5", "behoben": true, "lines": ["2"], "stations": ["Rathaus"], "start": "11.01.2021 03:30", "end": "10.01.2024 23:45"}' | bin/kafka-console-producer.sh --broker-list kafka_00:9094 --topic topic_interruptions


# deploy connector
curl -X POST -H "Content-Type: application/json" --data @kafka_connect/connector_stocks_topic_to_postgres.yaml http://localhost:8083/connectors

### Kafka Connect
# check running connectors
curl http://localhost:8083/connectors/

#################################################
################### NMAP ########################
#################################################

# Ping sweep -> icmp echo requests
nmap -sP 188.188.188.0/24

# TCP connect scan
nmap -sT 188.188.188.188
nmap -sT -p 80,443 188.188.188.188

# Stealthy scan
nmap -sS 188.188.188.188

# Get OS
nmap -O 188.188.188.188

# Agressiv scan (takes time)
nmap -A 188.188.188.188

#################################################
#################### Conda ######################
#################################################

# Install
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh ./Miniconda3-latest-Linux-x86_64.sh
source ~/miniconda3/bin/activate
conda init bash
conda --version

# Create new envirnment
conda create -n development python=3.8

# Activiere environemnt
conda activate development

# Install
conda install jupyter ipykernel -y

# Create new kernel for jupyter nodebook
ipython kernel install --name "development" --user

# Export environment
conda env export -n development > development.yml
# Import environment
conda env create -f development.yml


##################################################
###################### NFS #######################
##################################################

sudo mount -t nfs [IP/Hostname]:/srv/nfs /nfs

##################################################
################### MOSQUITTO ####################
###################################################

mosquitto_sub -h 188.20.0.14 -t "weather/balcony"
mosquitto_pub -h 188.20.0.14 -t "weather/balcony" -m "Hello MQTT"

##################################################
#################### PI-HOLE #####################
##################################################

# install
curl -sSL https://install.pi-hole.net | bash
# check if admin ui is running
sudo netstat -tulpn | grep 'lighttpd'
# change password
pihole -a -p
# update os
sudo apt update && sudo apt upgrade
# update pi-hole
pihole -up

## Backup Database script
@echo off
set source=""
set backupfolder=""
set backupfile=KeePassDB_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.kdbx
copy %source% %backupfolder%\%backupfile%

# change admin ui port so nginx can listen on port 80
sudo vim /etc/lighttpd/lighttpd.conf
sudo systemctl restart lighttpd

#################################################
################### Kubectl #####################
#################################################

complete -F __start_kubectl k
source <(kubectl completion bash)
source <(helm completion bash)

#################################################
#################### Helm #######################
#################################################

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

##################################################
################## File System ###################
##################################################

# dmesg logs
dmesg | grep -i "sda\|hda\|ata\|scsi"

# identify file systems
lsblk

# mount HDD
# create mount point
mkdir -p /mnt/hdd01
# mount HDD
mount /dev/sdb3 /mnt/hdd01
# make sure HDD mounts automaticaly
vim /etc/fdtab
# /dev/sdb3  /mnt/hdd01  ext4  defaults  0  2
