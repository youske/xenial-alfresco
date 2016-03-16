#!/bin/bash -eu
DATE=`TZ='Asia/Tokyo' date +"%Y%m%d%H"`
BASE=/alfresco-community
TARGET=${BASE}/alf_data
OUTDIR=/alfresco-recovery

alf_backup () {
  if [ -d ${TARGET} ] ; then
    pushd $PWD
    cd ${TARGET}
    [ -d ./postgresql ] && tar zcvf ${OUTDIR}/alf_pgsql_${DATE}.tar.gz ./postgresql || echo "skip"
    [ -d ./contentstore ] && tar zcvf ${OUTDIR}/alf_content_${DATE}.tar.gz ./contentstore || echo "skip"
    [ -d ./solr4/index ] && tar zcvf ${OUTDIR}/alf_solrindex_${DATE}.tar.gz ./solr4/index || echo "skip"
    popd
  fi
}

if [ -d $TARGET ] ; then
  [ -f ${BASE}/alfresco.sh ] && ${BASE}/alfresco.sh stop || :
  [ -d ${OUTDIR} ] && alf_backup || echo "skip backup"
  [ -f ${BASE}/alfresco.sh ] && ${BASE}/alfresco.sh start || :
fi
