sudo docker build ./nginx/. -t nginx --pull #nginx image should be build very quick
sudo docker build . -t webapp --pull #webapp image need hours to build
sudo docker-compose down
sudo docker-compose up -d --scale webapp=2
