#!/bin/bash -eu
DATE=`TZ='Asia/Tokyo' date +"%Y%m%d%H"`
BASE=/alfresco-community
TARGET=${BASE}/alf_data
OUTDIR=/alfresco-recovery

alf_restore() {
  DT=$1
  if [ -f ${OUTDIR}/alf_pgsql_${DT}.tar.gz ] ; then
    [ -d ./postgresql ] && rm -r ./postgresql || echo "remove skip pgsql_$DT"
    tar zxvf ${OUTDIR}/alf_pgsql_${DT}.tar.gz
    # file owner & permission change
    chown -R postgres:root ./postgresql
    chmod -R 700 ./postgresql
  fi

  if [ -f ${OUTDIR}/alf_content_${DT}.tar.gz ] ; then
    [ -d ./contentstore ] && rm -r ./contentstore || echo "remove skip contentstore_$DT"
    tar zxvf ${OUTDIR}/alf_content_${DT}.tar.gz
  fi

  if [ -f ${OUTDIR}/alf_solrindex_${DT}.tar.z ] ; then
    [ -d ./solr4/index ] && rm -r ./solr4/index || echo "remove skip solrindex_$DT"
    tar zxvf ${OUTDIR}/alf_solrindex_${DT}.tar.gz
  fi
}

if [ -d $TARGET ] ; then
  [ -f ${BASE}/alfresco.sh ] && ${BASE}/alfresco.sh stop || :
  if [ -d $OUTDIR ] ; then
    pushd $PWD
    cd ${TARGET}
    alf_restore $1
    popd
  fi
  [ -f ${BASE}/alfresco.sh ] && ${BASE}/alfresco.sh start || :
fi
