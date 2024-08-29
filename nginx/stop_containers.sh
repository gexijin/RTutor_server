#!/bin/bash

for i in $(seq 1 64)
do
    sudo docker stop "rt$i"
    sudo docker rm "rt$i"
done
