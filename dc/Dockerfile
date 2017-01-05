FROM busybox
MAINTAINER youske miyakoshi <youske@gmail.com>

ENV ALFRESCO_DATA=/alfresco-community
ENV ALF_DATA=${ALFRESCO_DATA}/alf_data
ENV ALF_DATA_CONTENTSTORE=${ALF_DATA}/contentstore \
#    ALF_DATA_POSTGRESQL=${ALF_DATA}/postgresql \
    ALF_DATA_INDEX=${ALF_DATA}/solr4/index

RUN mkdir -p ${ALF_DATA_CONTENTSTORE} && \
#    mkdir -p ${ALF_DATA_POSTGRESQL} && \
    mkdir -p ${ALF_DATA_INDEX}

VOLUME ${ALF_DATA_CONTENTSTORE}
# ${ALF_DATA_INDEX}
#${ALF_DATA_POSTGRESQL}
