dockerfile ubutu zenial with alfresco
=====================================

# build & run

    docker --file Dockerfile -t "<image tag name>" .

    docker run -it -p 8080:8080 --rm <image tag name>

# setup data containe
    docker pull busybox:latest
    docker run -it -v /loopback/apiprojects --name loopback_dataStore busybox /bin/sh

# change admin password
    docker run -it -v /optalfresco -e ADMIN_PASSWORD=hogehoge


# plugins
