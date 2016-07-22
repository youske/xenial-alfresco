# ubuntu xenial with alfresco
FROM ubuntu:xenial
MAINTAINER youske miyakoshi <youske@gmail.com>

#----- common -----

# s6-overlay
ENV S6OVERLAY_VERSION="v1.11.0.1"
ENV S6OVERLAY_URL="https://github.com/just-containers/s6-overlay/releases/download/${S6OVERLAY_VERSION}/s6-overlay-amd64.tar.gz"
ADD ${S6OVERLAY_URL} /tmp/

# entrykit
ENV ENTRYKIT_VERSION=0.4.0
ENV ENTRYKIT_FILE=entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
ENV ENTRYKIT_DOWNLOAD=https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/${ENTRYKIT_FILE}

ENV GOSU_VERSION=1.7
ENV GOSU_DOWNLOAD=https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64


ENV ALFRESCO_VERSION=201605 \
    ALFRESCO_BUILD=00010

ENV SHARE_PORT=8080 \
    FTP_PORT=21 \
    ADMIN_PASSWORD=admin \
    LANGUAGE=ja_JP.UTF-8 \
    DOWNLOAD_URL=http://dl.alfresco.com/release/community/${ALFRESCO_VERSION}-build-${ALFRESCO_BUILD}/alfresco-community-installer-${ALFRESCO_VERSION}-linux-x64.bin \
    ALFRESCO_BASE=/alfresco-community \
    ALFRESCO_AMPS=/alfresco-community/amps \
    ALFRESCO_AMPSSHARE=/alfresco-community/amps_share \
    ALFRESCO_LIBREOFFICE=/alfresco-community/libreoffice \
    DATA_DIR=/alfresco-community/alf_data \
    PACKAGE="fontconfig libice6 libsm6 libxt6 libxrender1 libfontconfig1 libglu1-mesa libcups2 libxinerama1 xvfb imagemagick ghostscript xfonts-base"

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y wget language-pack-ja  ${PACKAGE} && \
    update-locale LANG=${LANGUAGE}

# entrykit install
RUN wget -q --no-check-certificate ${ENTRYKIT_DOWNLOAD} -O- | tar zx && \
    chmod +x /entrykit && mv /entrykit /usr/bin && /usr/bin/entrykit --symlink

# gosu
RUN wget -q --no-check-certificate ${GOSU_DOWNLOAD} -O /usr/bin/gosu && chmod +x /usr/bin/gosu

# s6-overlay
RUN tar zxf /tmp/s6-overlay-amd64.tar.gz -C /


RUN wget -q ${DOWNLOAD_URL} -O /tmp/alfresco-community.bin && \
    chmod +x /tmp/alfresco-community.bin


RUN /tmp/alfresco-community.bin --mode text --installer-language en \
    --prefix ${ALFRESCO_BASE} \
    --postgres_port 5432 \
    --tomcat_server_port ${SHARE_PORT} \
    --tomcat_server_shutdown_port 8005 \
    --tomcat_server_ssl_port 8443 \
    --tomcat_server_ajp_port 8009 \
    --libreoffice_port 8100 \
    --alfresco_ftp_port ${FTP_PORT} \
    --alfresco_admin_password ${ADMIN_PASSWORD}

RUN  ln -s -f ${ALFRESCO_LIBREOFFICE}/scripts/libreoffice_ctl.sh ${ALFRESCO_LIBREOFFICE}/scripts/ctl.sh

# amps
RUN wget -qP ${ALFRESCO_AMPS} https://github.com/share-extras/js-console/releases/download/v0.6.0-rc1/javascript-console-repo-0.6.0.amp && \
    wget -qP ${ALFRESCO_AMPS} https://github.com/Alfresco/alfresco-support-tools/releases/download/1.10/support-tools-1.10.amp && \
    wget -qP ${ALFRESCO_AMPS} https://github.com/ntmcminn/alfresco-pdf-toolkit/releases/download/1.3-Beta3/pdf-toolkit-repo.amp && \
    wget -qP ${ALFRESCO_AMPSSHARE} https://github.com/ntmcminn/alfresco-pdf-toolkit/releases/download/1.3-Beta3/pdf-toolkit-share.amp && \
    wget -qP ${ALFRESCO_AMPSSHARE} https://github.com/teqnology/alfresco-header-share/blob/master/target/alfresco-header-share.amp?raw=true && \
#    wget -qP ${ALFRESCO_AMPSSHARE} http://www.form4.de/fileadmin/user_upload/Pix/Leistungen/alfresco/extensions/form4.alfresco.htmlwebpreviewer-1.0.0.amp && \
    ${ALFRESCO_BASE}/bin/apply_amps.sh

# remove downloadfile
RUN apt-get autoremove && apt-get autoclean && rm -rf /tmp/*

COPY scripts/ /alfresco_scripts

EXPOSE ${FTP_PORT} ${SHARE_PORT} 5432 8005  8100 8443


#VOLUME ["${ALFRESCO_BASE}/tomcat/bin/setenv.sh"]

WORKDIR /
ENTRYPOINT ["switch","shell=/bin/bash","--","/init"]
CMD ["/bin/bash","/alfresco_scripts/alfresco_run.sh"]
