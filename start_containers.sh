#!/bin/bash
# Number of uiuc containers, default 1
n=${1:-1}

for i in $(seq 1 $n)
do
    # ponytail: ports 5031+, clear of main rtutor's 5001-5030
    port=$((5030 + i))

    docker run -d --name "rt_uiuc$i" \
                --memory="6g" \
                --cpus="2.0" \
                --env-file=api.env \
                -p $port:3838 \
                -v ./shinyapps/:/srv/shiny-server/ \
                -v ./data/:/srv/data/ \
                -v ./shinylog/:/var/log/shiny-server/ \
                -v ./config/:/etc/shiny-server/ \
                -v ./classes/:/usr/local/src/myscripts/ \
                webapp-uiuc
done
