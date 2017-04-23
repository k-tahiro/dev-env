#!/bin/bash

docker run --name ${NAME:="dev-env"} \
           --privileged \
           -v /sys/fs/cgroup:/sys/fs/cgroup \
           -d \
           dev-env
docker exec -it ${NAME} /bin/bash
