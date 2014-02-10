JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk-amd64
PROPERTIES_FILE=$1

INSTALL_DIR=/usr/local
PROXY=
HADOOP_TEMP=/app/hadoop/tmp
DFS_DATA_DIR=/media/disk3
MASTER_URI=`cat $PROPERTIES_FILE | head -n 1`
echo $MASTER_URI
DFS_REPLICATION=2
NN_FORMAT=1
SLAVES_URI=`cat $PROPERTIES_FILE | tail -n 3`
echo $SLAVES_URI

echo "Using JAVA_HOME=$JAVA_HOME"

if [ ! -d "$JAVA_HOME" ];
then
echo "JAVA_HOME is pointing to $JAVA_HOME, which doesn't exist. Use -j option to specify the correct JAVA_HOME location"
        exit
fi

export JAVA_HOME=$JAVA_HOME
HADOOP_DIR=$INSTALL_DIR/hadoop

hadoop_tar=`find -name hadoop*.tar.gz`

if [ ! -f "$hadoop_tar" ];
then
echo "Hadoop tar not found at location : $hadoop_tar. You can download form hadoop mirror using -u option"
        exit
fi


function configure(){
        echo "-----------starting configuration-------------"
        sudo rm -rf $HADOOP_TEMP
        sudo mkdir -p $HADOOP_TEMP
        cd $HADOOP_DIR/conf/
        echo $MASTER_URI > masters
        echo $SLAVES_URI > slaves
        echo $MASTER_URI >> slaves
        echo "export JAVA_HOME=$JAVA_HOME" >> hadoop-env.sh
        echo -e "<?xml version=\"1.0\"?><?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?><configuration><property><name>hadoop.tmp.dir</name><value>$HADOOP_TEMP</value><description>A base for other temporary directories.</description></property><property><name>fs.default.name</name><value>hdfs://$MASTER_URI:54310</value><description>The name of the default file system. A URI whosescheme and authority determine the FileSystem implementation. Theuri's scheme determines the config property (fs.SCHEME.impl) namingthe FileSystem implementation class. The uri's authority is used todetermine the host, port, etc. for a filesystem.</description></property></configuration>" > core-site.xml
	echo -e "<?xml version=\"1.0\"?><?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?><configuration><property><name>dfs.replication</name><value>$DFS_REPLICATION</value><description>Default block replication.The actual number of replications can be specified when the file is created.The default is used if replication is not specified in create time.</description></property></configuration>" > hdfs-site.xml
        echo -e "<?xml version=\"1.0\"?><?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?><configuration><property><name>mapred.job.tracker</name><value>$MASTER_URI:54311</value><description>The host and port that the MapReduce job tracker runs </description></property></configuration>" > mapred-site.xml

}


# rsync to slaves $(cat /usr/local/hadoop/conf/slaves)
function copyToSlaves(){
        for srv in $SLAVES_URI ; do
echo "Copying to $srv...";
         rsync -avz --exclude='logs/*' $HADOOP_DIR/ $srv:$HADOOP_DIR/
         ssh $srv "rm -fR /app"
        done
}
function verifyJPS(){
        echo "-----------Verfing hadoop daemons-------------"
        for srv in $1; do
echo "Running jps on $srv.........";
        # ssh $srv "ps aux | grep -v grep | grep java"
         ssh $srv "jps"
        done
}

sudo rm -rf $HADOOP_DIR
tar xzf $hadoop_tar -C $INSTALL_DIR
sudo mv $INSTALL_DIR/hadoop-* $HADOOP_DIR
ssh $MASTER_URI "echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf"
ssh $MASTER_URI "echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf"
ssh $MASTER_URI "echo 'net.ipv6.conf.lo.disable_ipv6 = 1' >> /etc/sysctl.conf"
configure 
copyToSlaves 
echo "-----------starting hadoop cluster-------------"
if [ $NN_FORMAT -eq 1 ] ;then
echo "Formatting the NameNode........"
        ssh $MASTER_URI "$HADOOP_DIR/bin/hadoop namenode -format"
fi


ssh $MASTER_URI "$HADOOP_DIR/bin/start-dfs.sh"
ssh $MASTER_URI "$HADOOP_DIR/bin/start-mapred.sh"

#ssh $MASTER_URI "cd /usr/local"
ssh $MASTER_URI "wget http://mirror.apache-kr.org/hive/stable/hive-0.11.0.tar.gz"
ssh $MASTER_URI "tar xzvf hive-0.11.0.tar.gz"
ssh $MASTER_URI "mv hive-0.11.0 /usr/local/hive"
ssh $MASTER_URI "echo 'export HIVE_HOME=/usr/local/hive' >> ~/.bash_profile"
ssh $MASTER_URI "echo 'export PATH=$PATH:$HIVE_HOME/bin'    >> ~/.bash_profile"
#export MAVEN_HOME="/usr/local/apache-maven-3.1.1" 
#export PATH=$PATH:$MAVEN_HOME/bin 
#export PIG_HOME="/usr/local/pig-0.12.0" 
#export PATH=$PATH:$PIG_HOME/bin 

ssh $MASTER_URI "echo 'export HIVE_HOME=/usr/local/hive' >> ~/.bashrc"
ssh $MASTER_URI "echo 'export PATH=$PATH:$HIVE_HOME/bin' >> ~/.bashrc"
ssh $MASTER_URI "echo 'export HADOOP_HOME=/usr/local/hadoop' >> ~/.bashrc"
ssh $MASTER_URI "echo 'export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-i386' >>  ~/.bashrc "
ssh $MASTER_URI "echo 'export PATH=$PATH:$HADOOP_HOME/bin' >>  ~/.bashrc"
ssh $MASTER_URI "source ~/.bashrc"

#ssh $MASTER_URI "start-all.sh"

echo -a "<?xml version="1.0"?><?xml-stylesheet type="text/xsl" href="configuration.xsl"?><configuration><property><name>mapred.job.tracker</name><value>$MASTER_URI:54311</value></property></configuration>" > /usr/local/hive/src/conf/hive-site.xml

ssh $MASTER_URI "/usr/local/hadoop/bin/hadoop dfs -mkdir  /user"
ssh $MASTER_URI "/usr/local/hadoop/bin/hadoop dfs -mkdir  /user/root"
ssh $MASTER_URI "/usr/local/hadoop/bin/hadoop dfs -mkdir  /tmp"
ssh $MASTER_URI "/usr/local/hadoop/bin/hadoop dfs -mkdir  /user/hive"
ssh $MASTER_URI "/usr/local/hadoop/bin/hadoop dfs -mkdir  /user/hive/warehouse"
ssh $MASTER_URI "/usr/local/hadoop/bin/hadoop dfs -chmod 777   /tmp"
ssh $MASTER_URI "/usr/local/hadoop/bin/hadoop dfs -chmod 777   /user/hive/warehouse"
ssh $MASTER_URI "source ~/.bashrc"

verifyJPS $MASTER_URI
verifyJPS $SLAVES_URI
echo "done"
