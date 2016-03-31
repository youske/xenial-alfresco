#!/bin/bash -eu

ALFRESCO=/alfresco-community
${ALFRESCO}/alfresco.sh start

cat <<EOF >>~/.bashrc
trap "${ALFRESCO}/lfresco.sh stop; exit 0" TERM
EOF

exec /bin/bash
