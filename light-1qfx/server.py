from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor
import jinja2
import json
import os
import threading
from time import sleep
import subprocess
from threading import Timer
import time

#Global variables indicating the number of leaves and spines


def launchVMs(leaf,spine):
    print "I'm at launchVMs"
    total= leaf+spine
    ippair=leaf*spine
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
    print (spineips)
    print(peerleaf)
    print(spinenumber_list)
    dictlist=[]

    def create_dict(underlay_list):
        r=0
        q=leaf-1
        for p in range(0,total):
            if r < leaf:
                dicti={}
                dicti['hostname']=switchlist[r]
                dicti['loopback']="1.1.1."+str(r+1)
                dicti['asn']=('500'+str(r+1))
                dicti['underlay']=underlay_list[p]
                r=r+1
                dictlist.append(dicti)
                print(r)
            else :
                dicti2={}
                dicti2['hostname']=switchlist[r]
                dicti2['loopback']="1.1.1."+str(r+1)
                dicti2['asn']=('500'+str(r+1))
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
                                                                    # rand_int_var = randint(1, 10)
        subprocess.call(['sudo', 'vagrant', 'up'])
        print "Thread " + str(number) +" completed spinup"
        sendStringToIPad("VM:" + str(number))

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
        time.sleep(10)

                                                                    # This blocks the calling thread until the thread whose join() method is called is terminated.
                                                                    # From http://docs.python.org/2/library/threading.html#thread-objects
    for thread in thread_list:
        thread.join()

                                                                    # Demonstrates that the main process waited for threads to complete
    print "Done creating vms"

    subprocess.call(['sudo', 'ansible-playbook', "pb.conf.all.commit.yaml"])
    print("success-check config")




class IphoneChat(Protocol):
    def connectionMade(self):
        self.factory.clients.append(self) #add connected device to client list
        print "clients are ", self.factory.clients #print client list


    def connectionLost(self, reason):
        self.factory.clients.remove(self) #remove client from list when it disconnects

    def dataReceived(self, data): #function runs when new data is received from client
        print "Received message: " + data
        splitData = data.split(':')
        
        spines = int(splitData[0])
        leaves = int(splitData[1])

        print str(leaves) + " " + str(spines)
        if (int(leaves)>0 and int(spines)>0):
            print("I'm about to launch VMs")
            launchVMs(leaves,spines)
            print("successsss")



    

    def message(self, message):
        self.transport.write(message + '\n')


def sendStringToIPad(string):
    if len(factory.clients) > 0:
        factory.clients[0].message(string)
        




#Set up TCP Server
factory = Factory()
factory.protocol = IphoneChat
factory.clients = []
reactor.listenTCP(80, factory)
print "Iphone Chat server started"
reactor.run()





