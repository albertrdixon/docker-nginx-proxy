worker_processes 4;
user root root;
error_log /var/log/nginx/nginx-error.log info;

events {
  worker_connections 1024;
  accept_mutex on;
  use epoll;
}

http {
  upstream trans {
    {% if TRANSMISSION_HOST is defined %}
    server {{ TRANSMISSION_HOST }}:9091 fail_timeout=0;
    {% else %}
    server transmission:9091 fail_timeout=0;
    {% endif %}
  }

  server {
    listen 80 default deferred;
    location / {
      proxy_pass http://trans;
    }
  }
}

daemon off;