#!/bin/python
import time
import os
import sys
import subprocess
import os
num=int(sys.argv[1])
flavour=int(sys.argv[2])
image=int(sys.argv[3])
imgs={}
flvs={}
vms={}
def create(fff,iii,nnn):
	#flavor_id=int(sys.argv[1])
	#i_id=int(sys.argv[2])
	#name=sys.argv[3]
	#image_id=main.imgs[i_id][0]

	flavor_id=int(fff)
	i_id=int(iii)
	name=nnn
	image_id=imgs[i_id][0]

	print flavor_id
	print image_id
	print name

	image_id=str(image_id)
	image_id="".join(image_id.split())


	#print image_id
	comm="nova boot --flavor="+str(flavor_id)+" --image="+str(image_id)+" "+name
	os.system(comm)
	os.system("nova floating-ip-create siel > .ip")


	f=open(".ip","r")
	a=f.readlines()
	ip=a[3].split('|')[1]
	ip="".join(ip.split())
	comm="nova add-floating-ip "+name+" "+ip
	time.sleep(15)
	os.system(comm)


def main():
	os.system("sudo apt-get install python-novaclient")
#	os.system("export OS_USERNAME=cloud_project2")
	# can put in /etc/profile and run source /etc/profile
#	os.system("export OS_PASSWORD=cloud_project2")
#	os.system("export OS_TENANT_NAME=cloud_project2")
#	os.system("export OS_AUTH_URL=http://10.2.4.129:5000/v2.0/")
#	os.system("export OS_COMPUTE_API_VERSION=2.0")
	os.system("nova image-list > .images")
	f=open(".images","r")
	a=f.readlines()
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
	for i in range(0,num):
		#comm="python create_instance.py 2 2 hello"+str(i)
		#os.system(comm)
		#create_instance.createe(2,2,"hello"+str(i))
		create(flavour,image,"hello"+str(i))
		#create('2','6',"hello"+str(i))
	
	os.system("nova list > .vms")
	f=open(".vms","r")
	f1=open("pp","w")
        os.system("ifconfig > .pl")
        k=open(".pl","r")
        r=k.readlines()
        y=r[1].split()
        r=y[1].split(":")
        f1.write(str(s[1])+"\n")
	a=f.readlines()
	for i in range(2,len(a)):
		b=a[i].split('|')
		if(len(b)>1):
			try:
				#print b
				h=b[4].split(',')
				l=h[0].split('=')
				l[1]="".join(l[1].split())
				h[1]="".join(h[1].split())
				b[2]="".join(b[2].split())
				b[1]="".join(b[1].split())
				b[3]="".join(b[3].split())
				vms[b[2]]=[b[1],b[3],l[1],h[1]]
                                if "hello" in b[2]:
					f1.write(str(l[1])+"\n")
			except:
				print "IP not allocated"
	print vms
	f.close()
        f1.close()
	#destroy()
	#for i in vms:
	#	comm="nova floating-ip-delete "+vms[i][3]
	#	os.system(comm)
	
def destroy():
	for i in vms:
		if "hello" in i:
			comm="nova floating-ip-delete "+vms[i][3]
			os.system(comm)
			comm="nova delete "+i
			os.system(comm)

if __name__ == "__main__":
	 main()
