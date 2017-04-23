#!/bin/bash

docker run --privileged --name ${CONTAINER_NAME:-"dev-env"} -d dev-env
docker exec -it ${CONTAINER_NAME} /bin/bash
