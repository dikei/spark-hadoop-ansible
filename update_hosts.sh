#!/bin/bash

HOSTS=$(nova --no-cache list | awk '{ print $8 }' | grep public | sed 's/public=//' | sort)

readarray -t HOSTS_ARR <<< "$HOSTS"

SLAVES=""
for ip in "${HOSTS_ARR[@]}"
do
        SLAVES+="$ip ansible_ssh_user=\"{{ user }}\""
	SLAVES+='
'
done

MASTER=${HOSTS_ARR[0]}

cat << EOF
[app]
$MASTER ansible_ssh_user="{{ user }}"

[spark-master]
$MASTER ansible_ssh_user="{{ user }}"

[spark-slaves]
$SLAVES

[hdfs-master]
$MASTER ansible_ssh_user="{{ user }}"

[hdfs-slaves]
$SLAVES

[app]
$MASTER ansible_ssh_user="{{ user }}"

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

