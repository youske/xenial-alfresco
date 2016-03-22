# ubuntu xenial with alfresco

from ubuntu:xenial
MAINTAINER youske miyakoshi <youske@gmail.com>

ENV SHARE_PORT=8080 \
    ADMIN_PASSWORD=admin \
    LANGUAGE=ja_JP.UTF-8 \
    DOWNLOAD_URL=http://dl.alfresco.com/release/community/201602-build-00005/alfresco-community-installer-201602-linux-x64.bin \
    ALFRESCO_BASE=/alfresco-community \
    ALFRESCO_AMPS=/alfresco-community/amps \
    ALFRESCO_AMPSSHARE=/alfresco-community/amps_share \
    ALFRESCO_LIBREOFFICE=/alfresco-community/libreoffice \
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
    ln -s -f ${ALFRESCO_LIBREOFFICE}/scripts/libreoffice_ctl.sh ${ALFRESCO_LIBREOFFICE}/scripts/ctl.sh && \
    echo "end setup alfresco"

# amps
RUN wget -qP ${ALFRESCO_AMPS} https://github.com/share-extras/js-console/releases/download/v0.6.0-rc1/javascript-console-repo-0.6.0.amp && \
    wget -qP ${ALFRESCO_AMPS} https://github.com/pmonks/alfresco-bulk-import/releases/download/2.0.1/alfresco-bulk-import-2.0.1.amp && \
    wget -qP ${ALFRESCO_AMPS} https://github.com/Alfresco/alfresco-support-tools/releases/download/1.10/support-tools-1.10.amp && \
    wget -qP ${ALFRESCO_AMPS} https://github.com/ntmcminn/alfresco-pdf-toolkit/releases/download/1.3-Beta3/pdf-toolkit-repo.amp && \
    wget -qP ${ALFRESCO_AMPSSHARE} https://github.com/share-extras/js-console/releases/download/v0.6.0-rc1/javascript-console-share-0.6.0.amp && \
    wget -qP ${ALFRESCO_AMPSSHARE} https://github.com/ntmcminn/alfresco-pdf-toolkit/releases/download/1.3-Beta3/pdf-toolkit-share.amp && \
#    wget -qP ${ALFRESCO_AMPSSHARE} https://github.com/teqnology/alfresco-header-share/blob/master/target/alfresco-header-share.amp?raw=true && \
    wget -qP ${ALFRESCO_AMPSSHARE} http://www.form4.de/fileadmin/user_upload/Pix/Leistungen/alfresco/extensions/form4.alfresco.htmlwebpreviewer-1.0.0.amp && \
    ${ALFRESCO_BASE}/bin/apply_amps.sh
COPY alfresco_run.sh /alfresco_run.sh
COPY alfresco_backup.sh /alfresco_backup.sh
COPY alfresco_restore.sh /alfresco_restore.sh

#ENTRYPOINT ["/alfresco_run.sh"]
#CMD ["start"]
CMD ["sh"]

EXPOSE 21 5432 8005 8080 8100 8443
