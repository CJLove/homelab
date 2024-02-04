# gitea act_runner

Deploys a pool of 2 runners which will register with the self-hosted gitea instance

Depends on .env file with the following entries:

```
INSTANCE_URL=<URL of gitea>e.io:3000
RUNNER1_NAME=runner1
RUNNER2_NAME=runner2
RUNNER1_LABELS=
RUNNER2_LABELS=
REGISTRATION_TOKEN=<token from gitea>

```
