
# -*- coding: utf-8 -*-
# Foundations of Python Network Programming - Chapter 3 - tcp_sixteen.py
# Simple TCP client and server that send and receive 16 octets

import socket, sys
import time
import jinja2
import json
import os
import threading
from time import sleep
import subprocess
from threading import Timer
from subprocess import check_output


s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

HOST = '172.24.83.118'
PORT = 80
MAX = 1024

recvBuffer = ''

def deleteVMs():
    vms=subprocess.check_output(['sudo', 'VBoxManage', 'list', 'vms'])
    lines=(vms).splitlines()
    vmnames=[]
    for element in lines :
        vmnames.append(((element.split(' '))[0]).replace('\"',''))
    for vms in vmnames :
        subprocess.call(['sudo', 'VBoxManage', 'controlvm', vms, 'poweroff'])
    for vms in vmnames:
        subprocess.call(['sudo', 'VBoxManage', 'unregistervm', '--delete', vms])
    print('Deleted VMs')

def launchVMs(leaf,spine,socket):
    print "I'm at launchVMs"
    total= leaf+spine #total number of switches
    ippair=leaf*spine #total numbers of leaf/spine pairs
    print(total)
    p=0
    localip=[]
    peerip=[]
    switchlist=[]
    for i in range (1,total+1):
        switchlist.append("vqfx"+str(i))
    print switchlist
    for i in range (1,ippair+1):
        local_ip= "10.10."+str(i)+".1"
        peer_ip="10.10."+str(i)+".2"
        localip.append(local_ip)
        peerip.append(peer_ip)
    print(localip)
    print(peerip)
    spineips=[]
    peerleaf=[]
    q=0
    spinenumber_list=[]
    for q in range(0,spine):
        for i in range(q,ippair,spine):
            spineips.append(peerip[i])
            peerleaf.append(localip[i])
            spinenumber_list.append(i+1)
            #print(spineips)
            q=q+1
    print (spineips) #spine IPs
    print(peerleaf) #leaf IPs
    print(spinenumber_list)
    dictlist=[]

    def create_dict(underlay_list):
        r=0
        q=leaf-1
        for p in range(0,total):
            if r < leaf:
                dicti={}
                dicti['hostname']=switchlist[r]
                dicti['loopback']="10.10.139."+str(r+1)
                dicti['asn']=('500'+str(r+1))
                dicti['device']='leaf'
                dicti['cluster']='dummy'
                dicti['underlay']=underlay_list[p]
                r=r+1
                dictlist.append(dicti)
                print(r)
            else :
                dicti2={}
                dicti2['hostname']=switchlist[r]
                dicti2['loopback']="10.10.139."+str(r+1)
                dicti2['asn']=('500'+str(r+1))
                dicti2['device']="spine"
                dicti2['cluster']=str(r-leaf+1)+"."+str(r-leaf+1)+"."+str(r-leaf+1)+"."+str(r-leaf+1)
                dicti2['underlay']=underlay_list[p]
                dictlist.append(dicti2)
                r=r+1
        return(dictlist)
        #for q in range(leaf-1,total-1):
    #create_dict()
    #print(dictlist)
    def create_underlay():
     #tempdict={}
        m=0
        t=0
        x=0
        w=0
        h=0
        #q=leaf+1
        #templist=[]
        templist2=[]
        for s in range(0,total):
            if t < leaf:
                templist=[]
                q=leaf+1
                for m in range(0,spine):
                    tempdict={}
                    #templist=[]
                    tempdict['name']="em3."+str(s+1)+"0"+str(m)
                    tempdict['id']=str(s+1)+"0"+str(m)
                    tempdict['peer_loopback']='10.'+'10.'+'139.'+str(total-m)
                    tempdict['local_ip']=localip[x]
                    tempdict['peer_ip']=peerip[x]
                    tempdict['p_asn']=('500'+str(q))
                    q=q+1
                    x=x+1
                    print("here you are"+str(x))
                    #t=t+1
                    templist.append(tempdict)
                templist2.append(templist)
                t=t+1
                #templist2.append(templist)
            else:
                templist=[]
                for m in range(0,leaf):
                    tempdict={}
                    tempdict['name']="em3."+str(m+1)+"0"+str(h)
                    tempdict['id']=str(m+1)+"0"+str(h)
                    tempdict['peer_loopback']='10.'+'10.'+'139.'+str(m+1)
                    tempdict['local_ip']=spineips[w]
                    tempdict['peer_ip']=peerleaf[w]
                    tempdict['p_asn']=('500'+str(m+1))
                    w=w+1
                    #q=q+1
                    print("enter")
                    templist.append(tempdict)
                templist2.append(templist)
                t=t+1
                h=h+1
        return templist2

    def create_conf():
        template_file = "yam.j2"
        json_parameter_file = "sample.json"
        output_directory = "host_vars"

    # read the contents from the JSON files
        print("Read JSON parameter file...")
        config_parameters = json.load(open(json_parameter_file))

    # next we need to create the central Jinja2 environment and we will load
    # the Jinja2 template file (the two parameters ensure a clean output in the
    # configuration file)
        print("Create Jinja2 environment...")
        env = jinja2.Environment(loader=jinja2.FileSystemLoader(searchpath="."),
                             trim_blocks=True,
                             lstrip_blocks=True)
        template = env.get_template(template_file)

    # we will make sure that the output directory exists
        if not os.path.exists(output_directory):
                os.mkdir(output_directory)

    # now create the templates
        print("Create templates...")
        for parameter in config_parameters:
                result = template.render(parameter)
                f = open(os.path.join(output_directory, parameter['hostname'] + ".yaml"), "w")
                f.write(result)
                f.close()
                print("Configuration '%s' created..." % (parameter['hostname'] + ".yaml"))
        print("DONE")

    templist2=create_underlay()         
    print(templist2)
    final_json=create_dict(templist2)
    print(final_json)
    j = json.dumps(final_json, indent=4)
    f = open('sample.json', 'w')
    print >> f, j
    f.close()
    create_conf()
    
    
    
    def spinvm(number):
                                                     # Sleeps a random 1 to 10 seconds
        strToIpad = "VM:" + str(number) + '\n'                                                        # rand_int_var = randint(1, 10)
        subprocess.call(['sudo', 'vagrant', 'up'])
        print "Thread " + str(number) +" completed spinup"
        socket.sendall(strToIpad) 
        
        

    thread_list = []

    for i in range(1, total+1):
                                                                    # Instantiates the thread
                                                                    # (i) does not make a sequence, so (i,)
        t = threading.Timer(3.0,spinvm, args=(i,))              
        # Sticks the thread in a list so that it remains accessible
        thread_list.append(t)

                                                                    # Starts threads
    for thread in thread_list:
        thread.start()
        time.sleep(5)

                                                                    # This blocks the calling thread until the thread whose join() method is called is terminated.
                                                                    # From http://docs.python.org/2/library/threading.html#thread-objects
    for thread in thread_list:
        thread.join()

                                                                    # Demonstrates that the main process waited for threads to complete
    print "Done creating vms"

    subprocess.call(['sudo', 'ansible-playbook', "ebgpconf.yaml"])
    print("success-check config")

def evpnconf(socket):
    subprocess.call(['sudo', 'ansible-playbook', "evpnconf.yaml"])
    print("success-check config")
    socket.sendall("eVPNdone:\n")

def vtepconf(socket):
    subprocess.call(['sudo', 'ansible-playbook', "vtep.yaml"])
    print("success-check config")
    socket.sendall("VTEPdone:\n")


def recv_all(sock):

   global recvBuffer
   data = ''
   text = sock.recv(MAX)

   if (text[-1] == '\n') and ( not recvBuffer):
        data = text[0:len(text)-1]
   elif not recvBuffer:
        recvBuffer = text
   elif text[-1] == '\n':
        data = recvBuffer + text[0:len(text)-1]
   else:
        recvBuffer += text

   return data

def reply(socket):
    for i in range(1,6):
        string = "VM:" + str(i) + "\n"
        socket.sendall(string)
        time.sleep(2)
    socket.sendall("done:")

def processReceivedString(socket,data):
        splitData = data.split(':')

        if splitData[0] == "spineLeaf":
            spines = int(splitData[1])
            leaves = int(splitData[2])

            print str(leaves) + " " + str(spines)
            if (int(leaves)>0 and int(spines)>0):
                print("I'm about to launch VMs")
                launchVMs(leaves,spines,socket)
                print("successsss")
                socket.sendall("done:\n")

        elif splitData[0] == "delete":
            deleteVMs()
            socket.sendall("deleted:\n")

        elif splitData[0] == "disconnect":
            print "disconnect"

        elif splitData[0] == "eVPN":
            evpnconf(socket)
            

        elif splitData[0] == "VTEP":
            vtepconf(socket)




s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind((HOST, PORT))
s.listen(1)
while True:
  print 'Listening at', s.getsockname()
  sc, sockname = s.accept()
  print 'We have accepted a connection from', sockname
  print 'Socket connects', sc.getsockname(), 'and', sc.getpeername()
  message = recv_all(sc) #back or enable eBGP
  processReceivedString(sc, message)
  
  splitData = message.split(':')
  if splitData[0] == "spineLeaf":
    message = recv_all(sc) #enableEVPN or exit
    processReceivedString(sc, message)
    
    splitData = message.split(':')
    if splitData[0] == "eVPN":
        message = recv_all(sc) #enableVTEP or exit
        processReceivedString(sc, message)

        splitData = message.split(':')
        if splitData[0] == "VTEP":
            message = recv_all(sc) #exit
            processReceivedString(sc,message)
  
  sc.close() #close right away if message is back
  print 'Reply sent, socket closed'


