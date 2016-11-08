dockerfile ubuntu xenial with alfresco-community
================================================

# 概要
ubuntu (xenial) alfresco-community-インストーラのイメージを作成

ubuntu xenial をベースイメージ
alfresco-communityパッケージをインストールしたもの

なおインストールには require resource core 2+ RAM 4.0G+

# build

　　Dockerfileよりイメージを作成
    docker build --file Dockerfile -t "youske/xenial-alfresco" .

    同梱のdocker-composeの場合
    docker-compose build

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


# alfresco-global.properties

${TOMCAT_HOME}/shared/classes/alfresco-global.properties


# ftp enabled

alfresco-global.properties
    ftp.enabled=true

ftppasvモード
    Docker exporse port
    EXPOSE 56000-56009

    docker-compose.yml

    ports:
      - "36000-36009:56000-56009"

    docker run cli

    ducoekr run -it --rm -p 56000-56009:56000-56009 <image>
    http://stackoverflow.com/questions/28717464/docker-expose-all-ports-or-range-of-ports-from-7000-to-8000

# jvm チューニング
http://docs.alfresco.com/community/concepts/jvm-settings.html

HEAPSIZE
MEMSIZE

-XX;MempermSize=<memorySize>M
-Xms1G
-Xmx2G
-Dcom.sun.management.jmxremote


-XX:+UseConcMarkSweepGC -XX:+UseParNewGC

# timeout 設定変更

Alfresco uses sessions cookies which are valid for 60 minutes, which means users are logged out after being inactive for 60 minutes and have to login multiple times a day.

To increase the session timeouts, change the values in web.xml as below:
<session-config>
   <session-timeout>720</session-timeout>
</session-config>

The above config will keep the session active for 12 hours.

The web.xml files are found under the following folders:

ALFRESCO_HOME/tomcat/webapps/share/WEB-INF/web.xml
ALFRESCO_HOME/tomcat/webapps/alfresco/WEB-INF/web.xml

Once modified, restart Alfresco for the changes to take effect.
