# ubuntu xenial with alfresco

FROM ubuntu:xenial
MAINTAINER youske miyakoshi <youske@gmail.com>

ENV SHARE_PORT=8080 \
    ADMIN_PASSWORD=admin \
    LANGUAGE=ja_JP.UTF-8 \
    DOWNLOAD_URL=http://dl.alfresco.com/release/community/201602-build-00005/alfresco-community-installer-201602-linux-x64.bin \
    ALFRESCO_BASE=/alfresco-community \
    DATA_DIR=/alfresco-community/alf_data

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y wget language-pack-ja && \
    update-locale LANG=${LANGUAGE}

RUN wget -q -O alfresco-community.bin ${DOWNLOAD_URL} && \
    chmod +x alfresco-community.bin

RUN /alfresco-community.bin --mode text --installer-language en \
    --prefix ${ALFRESCO_BASE} \
    --postgres_port 5432 \
    --tomcat_server_port 8080 \
    --tomcat_server_shutdown_port 8005 \
    --tomcat_server_ssl_port 8443 \
    --tomcat_server_ajp_port 8009 \
    --libreoffice_port 8100 \
    --alfresco_ftp_port 21 \
    --alfresco_admin_password ${ADMIN_PASSWORD} && \
    rm -f /alfresco-community.bin && \
    apt-get autoremove && apt-get autoclean && \
    ln -s -f ${ALFRESCO_BASE}/libreoffice/scripts/libreoffice_ctl.sh ${ALFRESCO_BASE}/libreoffice/scripts/ctl.sh && \
    echo "end setup alfresco"

COPY alfresco_run.sh /alfresco_run.sh
COPY alfresco_backup.sh /alfresco_backup.sh
COPY alfresco_restore.sh /alfresco_restore.sh

ENTRYPOINT ["/alfresco_run.sh"]
CMD ["start"]

EXPOSE 21 5432 8005 8080 8100 8443
