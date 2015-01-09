worker_processes {{ WORKER_PROCESSES }};
user root root;
error_log /nginx/{{ LOG_FILE }} {{ LOG_LEVEL }};

events {
  worker_connections {{ WORKER_CONNECTIONS }};
  {% if WORKER_PROCESSES > 1 %}
  accept_mutex on;
  {% else %}
  accept_mutex off;
  {% endif %}
  use epoll;
  multi_accept on;
}

http {
  include mime.types;
  access_log off;

  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;

  keepalive_timeout 10;
  reset_timedout_connection on;
  client_body_timeout 10;
  send_timeout 2;

  gzip on;
  gzip_http_version 1.0;
  gzip_proxied any;
  gzip_min_length 500;
  gzip_disable "MSIE [1-6]\.";
  gzip_types text/plain text/html text/xml text/css
             text/comma-separated-values
             text/javascript application/x-javascript
             application/atom+xml;

  upstream app {
    {% if DESTINATION_PORT is defined %}
    server {{ DESTINATION_PORT|replace("tcp://", "")|replace("udp://", "") }} fail_timeout=0;
    {% endif %}
    {% if DESTINATION_ADDR is defined %}
    server {{ DESTINATION_ADDR }} fail_timeout=0;
    {% endif %}
  }

  server {
    listen 80 default deferred;
    location / {
      proxy_pass http://app;
    }
  }
}

daemon off;