import os
import sys 
hqlfile=sys.argv[1]
inputdir=sys.argv[2]
outputfile=sys.argv[3]

os.system("export HADOOP_HOME=/usr/local/hadoop")
os.environ['HADOOP_HOME'] = "/usr/local/hadoop"
os.system("/usr/local/hadoop/bin/hadoop dfs -copyFromLocal "+inputdir+" /user/root/")
comm="/usr/local/hive/bin/hive -f "+hqlfile+ " > " + outputfile
print comm
os.system(comm)
