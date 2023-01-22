# PiGallery2
This deploys PiGallery2 via Docker-compose

## Volumes mounted from host
- "/home/pigallery2/config:/app/data/config"
- "/home/pigallery2/db-data:/app/data/db"
- "/share/Pictures:/app/data/images:ro"
- "/home/pigallery2/tmp:/app/data/tmp"


