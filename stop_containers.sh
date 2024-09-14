#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: $0 <number_of_containers>"
  exit 1
fi

# Loop to create and start Docker containers based on the passed argument
for i in $(seq 1 $1)
do
    sudo docker stop "rt$i"
    sudo docker rm "rt$i"
done
