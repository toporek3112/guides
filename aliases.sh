##################################################
################### Aliases ######################
##################################################
alias c='xclip'
alias v='xclip -o'

# list
alias l='ls -lh'
alias ll='ls -lha'

# docker
alias k='kubectl'
alias compose='docker-compose'
alias dockeri='docker images'
alias dockerir='docker image rm'
alias dockerp='docker ps'
alias dockerpa='docker ps -a'
alias dockerl='docker logs'
alias dockerlf='docker logs -f'
alias dockzap='f() { docker stop $1 && docker rm $1; }; f'
alias dockernl='docker network ls'
alias dockervl='docker volume ls'
alias dockervp='docker volume prune'

# custom
alias cheader='sh ~/personal/header-comment.sh'

# dsi_project
alias set_producer_delays='export MODE="producer_delays" ;
export KAFKA_HOST="localhost:9092" ;
export KAFKA_TOPIC="topic_delays" ;
export SOURCE_URL="https://öffi.at/?archive=1&text=&types=2%2C3&page=" ;
export TIMEOUT_SECONDS="10" ;
export DB_CONNECTION="postgresql://postgres:postgres@localhost:5432/dsi_project" ;
'
alias set_producer_weather='export MODE="producer_weather" ;
export KAFKA_HOST="localhost:9092" ;
export KAFKA_TOPIC="topic_weather" ;
export KAFKA_INTERRUPTION_TOPIC="topic_delays" ;
export SOURCE_URL="https://archive-api.open-meteo.com/v1/archive"
export DB_CONNECTION="postgresql://postgres:postgres@localhost:5432/dsi_project" ;
'

alias set_consumer='
export MODE="consumer" ;
export KAFKA_HOST="localhost:9092" ;
export DB_CONNECTION="postgresql://postgres:postgres@localhost:5432/dsi_project" ;
'

alias set_setup_db='export MODE="setup_db" ;
export DB_TABLE="stops" ;
export KAFKA_HOST="localhost:9092 ;"
export DB_CONNECTION="postgresql://postgres:postgres@localhost:5432/dsi_project" ;
'