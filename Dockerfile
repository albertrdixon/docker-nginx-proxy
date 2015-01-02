FROM debian:jessie
MAINTAINER Albert Dixon <albert@timelinelabs.com>

ENV DEBIAN_FRONTEND noninteractive

RUN add-apt-repository -y ppa:nginx/stable &&\
    apt-get update
RUN apt-get --no-install-recommends -y nginx python3 &&\
    apt-get autoclean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN pip install envtpl

RUN rm -f /etc/nginx/nginx.conf
COPY configs/* /etc/nginx/
COPY scripts/* /usr/local/bin/
RUN chmod a+rx /usr/local/bin/*

WORKDIR /etc/nginx
ENTRYPOINT ["docker-start"]
EXPOSE 80 443

ENV PATH  /usr/local/bin:$PATH