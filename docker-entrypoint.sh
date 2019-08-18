#!/bin/bash
set -e

DRUID_HOME=/opt/druid

# Run as broker if needed
if [ "${1:0:1}" = '' ]; then
    set -- broker "$@"
fi

# if [ "$DRUID_XMX" != "-" ]; then
#     sed -ri 's/Xmx.*/Xmx'${DRUID_XMX}'/g' $DRUID_HOME/conf/druid/$1/jvm.config
# fi

# if [ "$DRUID_XMS" != "-" ]; then
#     sed -ri 's/Xms.*/Xms'${DRUID_XMS}'/g' $DRUID_HOME/conf/druid/$1/jvm.config
# fi

# if [ "$DRUID_MAXNEWSIZE" != "-" ]; then
#     sed -ri 's/MaxNewSize=.*/MaxNewSize='${DRUID_MAXNEWSIZE}'/g' $DRUID_HOME/conf/druid/$1/jvm.config
# fi

# if [ "$DRUID_NEWSIZE" != "-" ]; then
#     sed -ri 's/NewSize=.*/NewSize='${DRUID_NEWSIZE}'/g' $DRUID_HOME/conf/druid/$1/jvm.config
# fi

# if [ "$DRUID_HOSTNAME" != "-" ]; then
#     sed -ri "s~druid.host=.*~druid.host=${DRUID_HOSTNAME}~g" /opt/druid/conf/druid/$DRUID_NODE_TYPE/runtime.properties
# fi

# if [ "$DRUID_LOGLEVEL" != "-" ]; then
#     sed -ri "s~druid.emitter.logging.logLevel=.*~druid.emitter.logging.logLevel='${DRUID_LOGLEVEL}'~g" /opt/druid/conf/druid/_common/common.runtime.properties
# fi

if [ "$DRUID_USE_CONTAINER_IP" != "-" ]; then
    ipaddress=`ip a|grep "global eth0"|awk '{print $2}'|awk -F '\/' '{print $1}'`
    sed -ri "s~druid.host=.*~druid.host=${ipaddress}~g" $DRUID_HOME/conf/druid/$1/runtime.properties
fi

if [ "$POSTGRES_USER" != "-" ]; then
    sed -ri "s~druid.metadata.storage.connector.user.*~druid.metadata.storage.connector.user=${POSTGRES_USER}~g" $DRUID_HOME/conf/druid/_common/common.runtime.properties
fi

if [ "$POSTGRES_PASSWORD" != "-" ]; then
    sed -ri "s~druid.metadata.storage.connector.password.*~druid.metadata.storage.connector.password=${POSTGRES_PASSWORD}~g" $DRUID_HOME/conf/druid/_common/common.runtime.properties
fi

if [ "$DB_HOST" != "-" ]; then
#     sed -ri "s~druid.metadata.storage.connector.connectURI=.*~druid.metadata.storage.connector.connectURI=jdbc:postgresql://${POSTGRES_HOST}/druid~g" /opt/druid/conf/druid/_common/common.runtime.properties
  DB_CONNECT_URI="jdbc:${DB_TYPE}\:\/\/${DB_HOST}\:${DB_PORT}\/${DB_DBNAME}"
  sed -ri "s~druid.metadata.storage.connector.connectURI.*~druid.metadata.storage.connector.connectURI=${DB_CONNECT_URI}~g" $DRUID_HOME/conf/druid/_common/common.runtime.properties
fi

if [ "$ZOOKEEPER_HOST" != "-" ]; then
    sed -ri "s~druid.zk.service.host.*~druid.zk.service.host=$ZOOKEEPER_HOST~g" $DRUID_HOME/conf/druid/_common/common.runtime.properties
fi

# java $JAVA_OPTS -cp $DRUID_HOME/conf/druid/_common:$DRUID_HOME/conf/druid/$DRUID_NODE_TYPE:$DRUID_HOME/lib/* org.apache.druid.cli.Main server $DRUID_NODE_TYPE
java `cat ${DRUID_HOME}/conf/druid/$1/jvm.config | xargs` -cp ${DRUID_HOME}/conf/druid/_common:${DRUID_HOME}/conf/druid/$1:${DRUID_HOME}/lib/* org.apache.druid.cli.Main server "$@"