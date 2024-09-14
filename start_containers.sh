# Check if the number of loops is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <number_of_loops>"
  exit 1
fi

# Loop to create and start Docker containers based on the passed argument
for i in $(seq 1 $1)
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
