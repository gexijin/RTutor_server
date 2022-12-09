# Based on digital ocean One click app: Docker-ce

docker build ./nginx/. -t nginx --pull #nginx image should be build very quick

docker build . -t webapp --pull #webapp image need hours to build


echo 'All image are ready to run'

