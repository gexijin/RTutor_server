sudo docker stop nginx && sudo docker rm nginx
sudo docker run -d  --name nginx  -p 80:80 -p 443:443  nginx