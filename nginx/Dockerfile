# Nginx with sticky module
# More detail about sticky module: https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/overview
FROM nginx:1.31-alpine


# Copy custom configuration file from the current directory
COPY nginx.conf /etc/nginx/nginx.conf

# for HTTPS
# for *.RTutor.ai RTutor.ai
COPY  /etc/letsencrypt/live/rtutor.ai/fullchain.pem /etc/pki/nginx/wildcard.crt
COPY  /etc/letsencrypt/live/rtutor.ai/privkey.pem /etc/pki/nginx/private/wildcard.key
RUN chown nginx /etc/pki/nginx/wildcard.crt /etc/pki/nginx/private/wildcard.key

