#!/bin/bash

: ${DEVELOPER:="${USER}"}
: ${NAME:="dev-env"}

docker run --name ${NAME} \
           --privileged \
           -d \
           dev-env
docker exec -it -u ${DEVELOPER} ${NAME} /bin/bash
