#!/bin/bash

# Navigate to the idep directory
cd /home/ubuntu/RTutor_server

# Loop to create and start 50 Docker containers
for i in $(seq 1 64)
do
    # Correctly format the port number to include leading zero for single digit
    port=$(printf "50%02d" $i)

    docker run -d --name "rt$i" \
               --memory="6g" \
               --cpus="2.0" \
              --env-file=api.env \
               -p $port:3838 \
               -v ./shinyapps/:/srv/shiny-server/ \
               -v ./data/:/srv/data/ \
               -v ./shinylog/:/var/log/shiny-server/ \
               -v ./config/:/etc/shiny-server/ \
               -v ./classes/:/usr/local/src/myscripts/ \
               webapp
done
