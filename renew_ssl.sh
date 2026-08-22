# Run this script to renew the SSL certificate for *.rtutor.ai and rtutor.ai using Certbot with manual DNS challenge.
# Afterwards, just restart the server using 
# sudo sh restart_server.sh
# the files are mapped directly.
sudo certbot certonly \
  --manual \
  --preferred-challenges dns \
  -d rtutor.ai \
  -d '*.rtutor.ai'