# Grafana and Loki log aggregation 
This deploys Grafana, Loki and Promtail. Based heavily on https://docs.technotim.live/posts/grafana-loki/

## Loki
### Volumes mounted from host:
- `/home/grafana/loki` - Loki configuration and state information

## Promtail
### Volumes mounted from host:
- `/home/grafana/promtail` - Promtail configuratino and state information

## Grafana
### Volumes mounted from host:
- `/home/grafana/grafana` - Grafana state information

## Notes
- Grafana `USER` value depends on owner of `grafana` directory on the host 
- Promtail configured for journald (necessary for Fedora) and to enable syslog