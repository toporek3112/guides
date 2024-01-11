#################################################
################### Docker ######################
#################################################

# docker proxy settings directory:
# /etc/default/docker

# troubleshooting container
docker build -t debug-tools .
docker run -it --rm --network docker_dsi_custom_bridge debug-tools

#################################################
################### Postgres ####################
#################################################

psql -h dsi_postgres -p 5432 -U postgres -d postgres

#################################################
#################### Kafka ######################
#################################################

# consume from topic
bin/kafka-console-consumer.sh --bootstrap-server kafka_00:9094 --topic stocks_topic --from-beginning
# delete a topic
bin/kafka-topics.sh --bootstrap-server kafka_00:9094 --delete --topic stocks_topic
# list topics
bin/kafka-topics.sh --bootstrap-server kafka_00:9094 --list
# create topic
bin/kafka-topics.sh --bootstrap-server kafka_00:9094 --create --if-not-exists --replication-factor 1 --partitions 1 --config cleanup.policy=compact --topic stocks_topic

# deploy connector
curl -X POST -H "Content-Type: application/json" --data @kafka_connect/connector_stocks_topic_to_postgres.yaml http://localhost:8083/connectors

### Kafka Connect
# check running connectors
curl http://localhost:8083/connectors/

#################################################
################### NMAP ########################
#################################################

# scan network range
nmap -sn 188.188.188.1/24

# scan ip address
nmap -sV 188.188.188.22


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
conda install jupyter ipykernel

# Create new kernel for jupyter nodebook
ipython kernel install --name "development" --user

# Export environment
conda env export -n development > development.yml
# Export environment
conda env create -f development.yml
