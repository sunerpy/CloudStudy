#!/bin/bash
userProfile=/home/admin/gitcode/workshell/testprofile
nftHomeDir=/home/admin/gitcode/workshell/
cat<<-EOF >>${userProfile}
export JAVA_HOME=/usr/local/java_64
export JAVA_PATH=/usr/local/java_64/bin
export ORACLE_BASE=/home/db/oracle
export ORACLE_HOME=/home/db/oracle/product/11.2.0
export TNS_ADMIN=${nftHomeDir}
#DBSID设置
export ORACLE_SID=${dbSid}
export PATH=.:$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$ORACLE_HOME/lib32:$HOME/lib:$LD_LIBRARY_PATH
EOF

