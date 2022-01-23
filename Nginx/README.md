# Nginx with Artstore service

## Nginx
### Volumes mounted from host:
- `/home/nginx/default.conf` - nginx configuration file
- `/home/nginx/www` - www files

## Artstore service
- https://github.com/CJLove/artstore
### Volumes mounted from host:
- `/home/nginx/artstore` - artstore configuration and state info
- `/home/nginx/www` - www files

