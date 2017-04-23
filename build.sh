#!/bin/bash

if [ "PYTHON_VERSION" == "" ]; then
  PYTHON_VERSION="3.6.1"
fi

if [ "NODEJS_VERSION" == "" ]; then
  NODEJS_VERSION="6.10.2"
fi

docker build --build-arg PYTHON_VERSION="${PYTHON_VERSION}"  --build-arg NODEJS_VERSION="${NODEJS_VERSION}" .
