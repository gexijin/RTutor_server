#!/bin/bash
n=${1:-1}
for i in $(seq 1 $n)
do
    sudo docker stop "rt_uiuc$i"
    sudo docker rm "rt_uiuc$i"
done
