server {
  listen 80;

  location / {
    proxy_pass http://registry2:5000;

    proxy_set_header  Host              $http_host;   # required for docker client's sake
    proxy_set_header  X-Real-IP         $remote_addr; # pass on real client's IP
    proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header  X-Forwarded-Proto $scheme;
    proxy_read_timeout                  900;
    
    auth_basic "Restricted Area 12";
    auth_basic_user_file /tmp/htpasswd;
  }
}