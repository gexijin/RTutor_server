sudo docker stop nginx && sudo docker rm nginx
docker run \
  -d \
  --name nginx \
  -v /etc/letsencrypt:/etc/letsencrypt:ro \
  -p 80:80 \
  -p 443:443 \
  nginx