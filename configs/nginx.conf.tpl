worker_processes {{ WORKER_PROCESSES }};
user root root;
error_log {{ ERROR_LOG }} {{ LOG_LEVEL }};

events {
  worker_connections 1024;
  accept_mutex on;
  use epoll;
}

http {
  upstream app {
    {% if TRANSMISSION_HOST is defined %}
    server {{ TRANSMISSION_HOST }}:9091 fail_timeout=0;
    {% else %}
    server transmission:9091 fail_timeout=0;
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