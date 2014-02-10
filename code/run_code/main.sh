#!/bin/bash
hadoop_download="http://apache.claz.org/hadoop/common/hadoop-1.2.1/hadoop-1.2.1.tar.gz"
wget $hadoop_download
properties_file=$1
user="root"
slaves=`cat $properties_file | tail -n 3`
master=`cat $properties_file | head -n 1`
echo "slaves" $slaves
echo "slaves" $master
if [ ! -e ~/.ssh/id_rsa ]
then
ssh-keygen -f ~/.ssh/id_rsa -P ""
fi
for slave in $slaves
do
echo "ssh-copy-id -i $HOME/.ssh/id_rsa.pub $user@$slave"
ssh-copy-id -i $HOME/.ssh/id_rsa.pub $user@$slave
done
ssh-copy-id -i $HOME/.ssh/id_rsa.pub $user@$master
chmod a+x hadoop.sh
./hadoop.sh $1
