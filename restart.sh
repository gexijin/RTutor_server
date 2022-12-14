echo $(date) >> /home/ubuntu/log.txt
sudo docker-compose -f /home/ubuntu/RTutor_server/docker-compose.yml down
sudo docker-compose -f /home/ubuntu/RTutor_server/docker-compose.yml up -d --scale webapp=20