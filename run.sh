#!/bin/bash

: ${NAME:="dev-env"}

docker run --name ${NAME} \
           --privileged \
           -d \
           dev-env
docker exec -it ${NAME} /bin/bash
