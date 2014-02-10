pp=$1
M=`cat $pp | head -n 1`
S=`cat $pp | tail -n 3`
/usr/local/hadoop/bin/stop-all.sh
for srv in $S ; do
         ssh $srv "rm -fR /app"
         ssh $srv "rm -fR /usr/local/hadoop"
        done

rm -rf /usr/local/hadoop
rm -rf /usr/local/hive
rm -rf /app

