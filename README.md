dockerfile alpine linux with loopback
=====================================

# build & run

    docker --file Dockerfile -t "<image tag name>" .

    docker run -it -p 4440:4440 --rm <image tag name>

# setup data containe
    docker pull busybox:latest
    docker run -it -v /loopback/apiprojects --name loopback_dataStore busybox /bin/sh

# plugins
