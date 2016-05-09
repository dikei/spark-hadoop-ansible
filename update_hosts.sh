#!/bin/bash

HOSTS=$(nova --no-cache list | awk '{ print $8 }' | grep public | sed 's/public=//' | sort)

readarray -t HOSTS_ARR <<< "$HOSTS"

HOSTS_COUNT=${#HOSTS_ARR[@]}

SLAVES=""
for ip in "${HOSTS_ARR[@]:1}"
do
        SLAVES+="$ip ansible_ssh_user=\"{{ user }}\""
	SLAVES+='
'
done

SPARK_MASTER=${HOSTS_ARR[0]}
APP_MASTER=${HOSTS_ARR[0]}
HDFS_MASTER=${HOSTS_ARR[0]}

cat << EOF
[app]
$APP_MASTER ansible_ssh_user="{{ user }}"

[spark-master]
$SPARK_MASTER ansible_ssh_user="{{ user }}"

[spark-slaves]
$SLAVES

[hdfs-master]
$HDFS_MASTER ansible_ssh_user="{{ user }}"

[hdfs-slaves]
$SLAVES

[masters:children]
spark-master
hdfs-master

[slaves:children]
spark-slaves
hdfs-slaves

[spark:children]
spark-master
spark-slaves

[hdfs:children]
hdfs-master
hdfs-slaves
EOF

