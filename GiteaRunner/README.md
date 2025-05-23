# gitea act_runner

Deploys a pool of 4 runners which will register with the self-hosted gitea instance

Depends on .env file with the following entries:

```
INSTANCE_URL=<URL of gitea>e.io:3000
RUNNER1_NAME=runner1
RUNNER2_NAME=runner2
RUNNER1_NAME=runner3
RUNNER2_NAME=runner4
RUNNER1_LABELS=
RUNNER1_LABELS=
RUNNER3_LABELS=
RUNNER4_LABELS=
REGISTRATION_TOKEN=<token from gitea>

```
