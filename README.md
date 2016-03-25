dockerfile ubutu zenial with alfresco
=====================================
# 概要
alfresco-communityのイメージを作成

ubuntu xenial をベースイメージ
alfresco-communityパッケージをインストールしたもの

require resource core 2+ RAM 4.0G+

# build

    docker build --file Dockerfile -t "youske/xenial-alfresco" .

# run

    docker run -it -p 8080:8080 -p 21:21 --volumes-from alf_datacontainer youske/xenial-alfresco

# change admin password

    docker run -it -p8080:8080 -e ADMIN_PASSWORD=hogehoge

# shutdown & restart
    docker exec -it <container name> /bin/bash
    $> /alfresco-community/alfresco.sh stop postgresql

    $> /alfresco-community/alfresco.sh restart postgresql

# setup data container
    データコンテナを作ることでデータのやり取り、復元を行うことができる。
    docker pull busybox:latest
    docker run -it -d -v /alfresco-recovery --name alf_datacontainer busybox /bin/sh

    要件としては/alfresco-recovery　ディレクトリがあること

# data backup

　　上記データコンテナを想定しているので作っておき　runのパラメータにして
    --volumes-from alf_datacontainer を指定して起動する。

    alfresco_backup.sh
    注意点　初回起動直後にpostgresqlを停止させると必要なデータがキチンと生成されないようなので利用しない
    目安としてalfresco/shareにadmin権限でログインができる事を確認してからバックアップすること

# data recover

    alfresco-restore.sh
