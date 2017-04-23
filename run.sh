#!/bin/bash

docker run --privileged --name ${NAME:="dev-env"} -d dev-env
docker exec -it ${NAME} /bin/bash
