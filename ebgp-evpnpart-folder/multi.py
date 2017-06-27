import threading
from random import randint
from time import sleep
import time
import subprocess
import os
from threading import Timer

def spinvm(number):
                                                                # Sleeps a random 1 to 10 seconds
                                                                # rand_int_var = randint(1, 10)
    subprocess.call(['sudo', 'vagrant', 'up'])    
    print "Thread " + str(number) +"completed spinup"

thread_list = []

for i in range(1, 6):
    								# Instantiates the thread
    								# (i) does not make a sequence, so (i,)
    t = threading.Timer(10.0,spinvm, args=(i,))
    								# Sticks the thread in a list so that it remains accessible
    thread_list.append(t)

								# Starts threads
for thread in thread_list:
    time.sleep(15)
    thread.start()

								# This blocks the calling thread until the thread whose join() method is called is terminated.
								# From http://docs.python.org/2/library/threading.html#thread-objects
for thread in thread_list:
    thread.join()
								# Demonstrates that the main process waited for threads to complete
print "Done"
