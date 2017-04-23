#!/bin/bash

: ${DEVELOPER:="${USER}"}
: ${PYTHON_VERSION:="3.6.1"}
: ${NODEJS_VERSION:="6.10.2"}

docker build --build-arg DEVELOPER="${DEVELOPER}" \
             --build-arg PYTHON_VERSION="${PYTHON_VERSION}" \
             --build-arg NODEJS_VERSION="${NODEJS_VERSION}" \
             -t dev-env \
             .
