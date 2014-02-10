#python mainscript.py 1 /root/oozieProject /root/output  Airawat.Oozie.Samples.LogEventCount /root/oozieProject/workflowJavaMapReduceAction/lib/LogEventCount.jar oozieProject/data/*/*/*/*/*

import os
import time
import sys
number=sys.argv[1]
inputfile=sys.argv[2]
outputfile=sys.argv[3]
classtobeused=sys.argv[4]
jarorhqlfile=sys.argv[5]
inputpath=sys.argv[6]
#os.system("python main.py "+ number +" 2 6")
os.system("./main.sh pp")
time.sleep(90)
os.system("source ~/.bashrc")
if ".hql" in jarorhqlfile:
	os.system("python runhive.py "+jarorhqlfile+" "+inputfile+" " +outputfile)
else:
	comm="python runmapreduce.py "+jarorhqlfile +" "+ inputfile+" " +outputfile+" " +classtobeused+" "+inputpath
	print comm
	os.system(comm)
