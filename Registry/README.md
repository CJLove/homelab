# Docker registry and registry UI
This deploys a local Docker registry via https using a self-signed certificate
along with the Quiq Registry UI (https://hub.docker.com/r/quiq/docker-registry-ui/tags/)

## Registry
### Volumes mounted from host
- `/home/registry/registry` - container storage
- `/home/registry/reg_certs` - certificate & key for https support
- `/home/registry/config.yml` - registry configuration

## Registry UI
### Volumes mounted from host
- `/home/registry/ui_config.yml` - UI configuration
- `/home/registry/data` - UI state information
- `/home/registry/reg_certs/ca.crt` - CA certificate for accessing a self-signed registry

## CA and certificate generation
The `create-certs.sh` script can create a CA and certificate for a specified host.  Usage is:

```
create-certs.sh <path> <shortHost> <fullHost> <ip> <alias>
```
Where:
- <path> is the path to create the `reg_certs` directory
- <shortHost> is the short hostname
- <fullHost> is the fully qualified hostname
- <alias> is an alias for the host (e.g. for local DNS)