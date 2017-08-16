# iOS-Python-TCP-Interface
## Application Overview
The purpose of this iOS application is to allow users to dynamically configure and launch a Data Center (DC) IP Fabric consisting of a L3 Clos Spine-Leaf architecture of Juniper Networks’ virtual QFX switches. The application will enable field Systems Engineers at Juniper to showcase the versatile applications of our Data Center Switching solutions to customers. Through this Zero-Touch-Provisioning user interface, even clients who do not have much networking knowledge can automatically configure a DC IP Fabric.

## Application Features
With the application, users are able to:
* Design an L3 Clos architecture by selecting the desired number of spine and leaf switches
* Automatically configure the aforementioned number of spine and leaf vQFX switches on VirtualBox Linux machines
* Launch vQFXs at the click of a button
* Connect the vQXFs using an eBGP underlay
* Enable an eVPN overlay
* Configure a VTEP tunnel between leaf switches
* Receive feedback as to which virtual machines were successfully configured in real-time
* Delete the DC POD by automatically closing all machines

## Downloading the Application

### Dependencies
In order for the application to be run successfully, the host computer needs to contain the following software:
* Python (version 2.7 or later)
* Xcode
* Ansible 
* Vagrant (version 1.7 or later)
* VirtualBox (version 5.0.10 or later)

### Downloading Dependencies
### Install Vagrant
Download: https://www.vagrantup.com/downloads.html

__Note__: If you are using an old version of Linux (Ubuntu 14.04, 14.10, etc.) the version installed with apt-get will most likely not work. In this case, you need to update the version manually.
Installation for Ubuntu:
```
wget https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb
sudo dpkg -i vagrant_1.8.1_x86_64.deb

```

### Install VirtualBox
Download: https://www.virtualbox.org/wiki/Downloads

### Download and Install the vQFX Box file locally
Download: http://www.juniper.net/support/downloads/?p=vqfxeval#sw

__Note__: Because vqfx10k boxes are not available on Vagrant Cloud yet, you will have to install them manually first. Use the following commands depending on the package you wish to use:

Installation commands (full package):
```
vagrant box add juniper/vqfx10k-refull /{path to box file}/vqfx10k-re-virtualbox.box
vagrant box add juniper/vqfx10k-pfefull /{path to box file}/vqfx10k-pfe1-virtualbox.box
```
__Note__: Both vqfx10k-re and vqfx10k-pfe need to be installed for full package. For an explanation of light mode versus full mode, see “Using Light Mode vs. Full Mode.” 

Installation commands (light package):
```
vagrant box add juniper/vqfx10k-re /{path to box file}/vqfx10k-re-virtualbox.box
```

### Install Ansible
Installation commands for MacOS:
```
sudo easy_install pip
sudo pip install ansible
sudo ansible-galaxy install Juniper.junos
sudo pip install junos-eznc
```

Installation commands for Ubuntu/Linux:
```
apt-get install ansible
ansible-galaxy install Juniper.junos
```

## One-Time Application Installation on an iOS Device
The user has two platforms on which they can run the iOS application: on a physical iOS device or on an Xcode simulator. Follow these steps to load the Xcode project onto a host device, such as an iPhone or iPad, or on the simulator:
1. Open the iPhoneClient.xcodeproj file on Xcode.
2. Open the Connection.swift file on the left menu of files.
3. Locate the IP Address of your computer on the network. On a Mac, this can be done by going to System Preferences and selecting “Network.” 
4. Change the serverAddress string to the IP address of your computer on the network. Also open the server.py file and change the HOST variable to this IP address.
5. Open the iPhoneClient.xcodeproj file on Xcode.
6. Select the device listed in the top left corner next to the iPhoneClient icon. By default, it is set to a simulator. If you wish to use a simulator, select “iPad Air 2” and skip to Step 9.
7. Connect a physical iOS device to your computer.
8. Select the physical device from the drop-down menu in Xcode
9. Press the “Start” triangle button in the top left corner of the screen to build the XCode project on the iOS device. The application can now be launched from an icon named “iPhoneClient” on the iOS device.
10. If you use a physical device to run the application, you simply need to click on the app’s icon on your screen every time you wish to run it. If you use a simulator, you will need to open Xcode and press the “Start” triangle in the upper left corner to launch the app each time.

## Using Light Mode vs. Full Mode Application
There are two branches of the Git repository: “master” and “full-package.” These correspond to the two different types of vQFX Boxes: light mode and full mode. Light mode boxes only launch VirtualBox instances of the Routing Engine (RE) for each vQFX, while full mode boxes launch two VirtualBox instances per vQFX: the RE and the Packet Forwarding Engine (PFE). Therefore, full mode images require much more processing power on the computer.

From an application standpoint, the full package supports all of the networking features of the application, such as enabling VTEP. However, full mode should not be used to configure more than four vQFXs total, as each machine requires two VirtualBox images, and having too many would crash the host computer.

The light mode of the application, on the other hand, supports all capabilities except for enabling VTEP. It can be used to spin up a maximum of ten vQFXs, since light mode does not use as much of the computer’s memory as full mode.

To use the light mode of the application, navigate to the directory at which you cloned the Git repository and enter the command:
```
git checkout master
```

To use the full mode of the application, navigate to the same directory and run the command: 
```
git checkout full-package
```

## Launching the Application
### Launching the Back-End Python Server
Before the application can be launched on the iPad, the back-end Python script must be running on the computer. **The computer and iOS device must be on the same network in order for communication between the two to be possible.** Follow these steps to launch the Python server code:
1. Navigate to the light-1qfx or full-1qfx directory (depending on which mode of vQFX image you wish to generate)
2. Launch the server.py Python file. **This file must be run with sudo privileges.** The Python server is now running and waiting for a socket connection from the iOS device.
3. Optionally, open VirtualBox to see the virtual machines launching in real-time.
Once the Python script is running, click on the “iPhoneClient” application on the iOS Device. This should launch the application, and it will be ready for use at this point.

## SSH to devices spun up:
ssh -p 2222(2200,2201,2202......so on) root@127.0.0.1
example: ssh -p 2222 root@127.0.0.1
password:  Juniper
## Further Information
For more detailed installation and usage instructions, see the "User Manual" file in the GitHub repository.





