#!/usr/bin/env bash

# format EBS volume
if [ `file -s ${device_name} | cut -d ' ' -f 2` = 'data' ]; then
    mkfs -t ext4 ${device_name}
fi

# create the mount point
if [ ! -d ${mount_point} ]; then
    mkdir -p ${mount_point}
fi

# mount the volume
if ! grep ${device_name} /etc/mtab > /dev/null; then
    mount ${device_name} ${mount_point}
fi

# update fstab
if ! grep ${mount_point} /etc/fstab > /dev/null; then
    echo "${device_name} ${mount_point} ext4 defaults,nofail 0 2" >> /etc/fstab
fi

# update the kafka log.dir
cat /etc/kafka/server.properties \
    | sed 's|log.dirs=/var/lib/kafka|log.dirs=${mount_point}/kafka-data|' \
    > /tmp/server.properties
echo >> /tmp/server.properties
mv /tmp/server.properties /etc/kafka/server.properties

# set the group and owner on Mounted kafka log dir
if [ ! -d ${mount_point}/kafka-data ]; then
    mkdir ${mount_point}/kafka-data
    chgrp -R confluent ${mount_point}/kafka-data
    chown -R cp-kafka ${mount_point}/kafka-data
fi

sudo systemctl enable confluent-zookeeper

# use this command to start kafka don't use systemctl command.
nohup /usr/bin/kafka-server-start /etc/kafka/server.properties

# start again as enable is not starting the services
sudo systemctl start confluent-zookeeper
