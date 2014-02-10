#!/bin/python
import os
# can put in /etc/profile and run source /etc/profile
os.system("export OS_USERNAME=cloud_project2")
os.system("export OS_PASSWORD=cloud_project2")
os.system("export OS_TENANT_NAME=cloud_project2")
os.system("export OS_AUTH_URL=http://10.2.4.129:5000/v2.0/")
os.system("export OS_COMPUTE_API_VERSION=2.0")

os.system("nova image-list > .images")
f=open(".images","r")
a=f.readlines()
imgs={}
count=1
for i in range(2,len(a)):
	b=a[i].split('|')
	if(len(b)>1):
		b[1]="".join(b[1].split())
		b[2]="".join(b[2].split())
		b[3]="".join(b[3].split())
		b[4]="".join(b[4].split())
		imgs[count]=[b[1],b[2],b[3],b[4]]
		count=count+1
print imgs
f.close()


os.system("nova flavor-list > .flavor")
f=open(".flavor","r")
a=f.readlines()
flvs={}
for i in range(2,len(a)):
	b=a[i].split('|')
	if(len(b)>1):
		#print b
		b[1]="".join(b[1].split())
		b[2]="".join(b[2].split())
		b[3]="".join(b[3].split())
		b[4]="".join(b[4].split())
		b[5]="".join(b[5].split())
		b[6]="".join(b[6].split())
		b[7]="".join(b[7].split())
		b[8]="".join(b[8].split())
		flvs[b[1]]=[b[2],b[3],b[4],b[5],b[6],b[7],b[8]]
print flvs 
f.close()

#call create_instance 
os.system("nova list > .vms")
f=open(".vms","r")
a=f.readlines()
vms={}
for i in range(2,len(a)):
	b=a[i].split('|')
	if(len(b)>1):
		#print b
		h=b[4].split(',')
		l=h[0].split('=')
		l[1]="".join(l[1].split())
		h[1]="".join(h[1].split())
		b[2]="".join(b[2].split())
		b[1]="".join(b[1].split())
		b[3]="".join(b[3].split())
		vms[b[2]]=[b[1],b[3],l[1],h[1]]
print vms
f.close()

