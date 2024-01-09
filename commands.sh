#################################################
################### NMAP ########################
#################################################

# scan network range
nmap -sn 188.188.188.1/24

# scan ip address
nmap -sV 188.188.188.22


#################################################
##################### Conda #####################
#################################################

# Install
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh ./Miniconda3-latest-Linux-x86_64.sh
source ~/miniconda3/bin/activate
conda init bash
conda --version

# Create new envirnment
conda create -n mathematics python=3.8

# Activiere environemnt
conda activate mathematics

# Install
conda install jupyter ipykernel

# Create new kernel for jupyter nodebook
ipython kernel install --name "mathematics" --user

# Export environment
conda env export -n mathematics > mathematics.yml
# Export environment
conda env create -f mathematics.yml
