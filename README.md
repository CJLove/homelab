# Homelab services
This repo deploys various homelab services via `docker-compose`:

- OpenGrok
- WikiJS
- Nginx with Artstore service
- Docker registry and UI
- Uptime-kuma dashboard
- Grafana & Loki
- PiHole

## Conventions
I have separate users created for each service on the host, going back to when I was running these
services rootless using Podman. Each user is added to the `docker` group and the service is started as follows:

```bash
$ docker-compose up -d --force-recreate
```

Where appropriate the user home directory is backed up.
