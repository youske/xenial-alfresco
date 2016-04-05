#!/bin/bash -eu

ALFRESCO=/alfresco-community
${ALFRESCO}/alfresco.sh start
cat >> /dev/null
cat <<EOF >>~/.bashrc
trap "${ALFRESCO}/lfresco.sh stop; exit 0" TERM
EOF

#exec /bin/bash
