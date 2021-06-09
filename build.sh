#!/bin/sh

TAG=${1:-"node-php-fpm72"}

docker build -f Dockerfile --tag ${TAG}:latest .

