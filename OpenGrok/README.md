# OpenGrok notes
- Deploys OpenGrok: https://oracle.github.io/opengrok/

## Volumes from the host:
- `/home/opengrok/Etc` - configuration files
- `/home/opengrok/Data` - indexing data
- `/home/opengrok/Source` - Source projects to be indexed

## Resyncing
- Automatic resync is disabled via `SYNC_PERIOD_MINUTES=0`
- See `index.sh` for an example of how to force a manual resync (e.g. from a cron job on the host)