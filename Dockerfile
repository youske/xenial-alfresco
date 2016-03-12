# ubuntu xenial with alfresco

from ubuntu:xenial
MAINTAINER youske miyakoshi <youske@gmail.com>

ENV SERVER_URL="http://192.168.99.100:4440" \
    ADMIN_PASSWORD=admin \
    ALFRESCO_BASE=/opt/alfresco-community \
    DATA_DIR=/opt/alfresco-community/alf_data

COPY alfresco_run.sh /alfresco_run.sh

RUN apt-get update && \
    apt-get install -y wget language-pack-ja && \
    update-locale LANG=ja_JP.UTF-8

RUN wget -q -O alfresco-community.bin http://dl.alfresco.com/release/community/201602-build-00005/alfresco-community-installer-201602-linux-x64.bin && \
    chmod +x alfresco-community.bin

RUN /alfresco-community.bin --installer-language en --prefix ${ALFRESCO_BASE} --postgres_port 5432 --alfresco_ftp_port 21 --alfresco_admin_password ${ADMIN_PASSWORD} && \
    rm -f /alfresco-community.bin
#ENTRYPOINT ["/etc/init.d/alfresco"]
VOLUME ["${DATA_DIR}"]
CMD ["bash"]

EXPOSE 21 5432 8005 8080 8100 8443
