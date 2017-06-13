from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor
import subprocess
import os

startVar = "Start"

class IphoneChat(Protocol):
    def connectionMade(self):
        self.factory.clients.append(self) #add connected device to client list
        print "clients are ", self.factory.clients #print client list
        self.transport.write("Hello!")

    def connectionLost(self, reason):
        self.factory.clients.remove(self) #remove client from list when it disconnects

    def dataReceived(self, data): #function runs when new data is received from client
        print "Received message: " + data
	if (data==startVar):
	    #subprocess.call(['sudo', 'vagrant', 'up'])
		print("successfully started virtual machines")

    def message(self, message):
        self.transport.write(message + '\n')
#Set up TCP Server
factory = Factory()
factory.protocol = IphoneChat
factory.clients = []
reactor.listenTCP(80, factory)
print "Iphone Chat server started"
reactor.run()
