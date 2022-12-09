FROM rocker/shiny-verse

MAINTAINER Ge lab "xijin.ge@sdstate.edu"
RUN apt-get update || apt-get update
RUN apt-get update -qq && apt-get install -y \
  git-core \
  wget \
  unzip \
  vim
#RUN  apt-get install -y libgdal-dev gdal-bin libproj-dev proj-data proj-bin libgeos-dev 

COPY ./classes /usr/local/src/myscripts
COPY ./shinyapps /srv/shiny-server

RUN mkdir -p /srv/data

WORKDIR /usr/local/src/myscripts

EXPOSE 3838

# Install required R libraries
RUN Rscript librarySetup.R
