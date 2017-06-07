from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor

class IphoneChat(Protocol):
    def connectionMade(self):
        self.factory.clients.append(self) #add connected device to client list
        print "clients are ", self.factory.clients #print client list

    def connectionLost(self, reason):
        self.factory.clients.remove(self) #remove client from list when it disconnects

    def dataReceived(self, data):
        print "Received message: " + data

    def message(self, message):
        message = "Hello, iPhone!"
        self.transport.write(message + '\n')

factory = Factory()
factory.protocol = IphoneChat
factory.clients = []
reactor.listenTCP(80, factory)
print "Iphone Chat server started"
reactor.run()
