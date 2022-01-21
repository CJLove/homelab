#!/bin/bash

container=$(docker ps |grep opengrok|awk '{print $1}')
if [ -n "$container" ]; then
	echo "Updating Opengrok indices..."
	docker exec "$container" /usr/bin/curl localhost:8081/reindex
fi

echo "Done"

exit 0
