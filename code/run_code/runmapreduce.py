import os
import sys 
jarfile=sys.argv[1]
inputfile=sys.argv[2]
outputfile=sys.argv[3]
classtobeused=sys.argv[4]
inputpath=sys.argv[5]
comm="/usr/local/hadoop/bin/hadoop dfs -copyFromLocal "+inputfile+" /user/root/"
print comm
os.system(comm)
os.system("/usr/local/hadoop/bin/hadoop dfs -rmr /user/root/out2")
comm="/usr/local/hadoop/bin/hadoop jar "+ jarfile +" "+ classtobeused + " /user/root/"+inputpath+" /user/root/out2"
print comm
os.system(comm)
os.system("/usr/local/hadoop/bin/hadoop dfs -cat /user/root/out2/part* > "+ outputfile)
