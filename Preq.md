# WindowsTools

Install chocolatey from the instructions given in the link below.

https://chocolatey.org/docs/installation

```
choco install virtualbox --version=7.1.4 -y
```
```
choco install vagrant --version=2.4.3 -y
```

<br>

# MacOS Tools

Install brew from the instructions given in the link below.


https://brew.sh/

After installing homebrew
Create a file in users home directory with name .curlrc with content “-k” 
(-k without quotes and give a new line character after -k.)

Steps:

1. OpenTerminal
2. Execute below command
```
echo -k > ~/.curlrc
```
3. Execute below command to see -k in file ~/.curlrc 
```
cat ~/.curlrc
```

Run all the below commands in Terminal


### (virtualbox command is not For MacOs M1/M2)
```
brew install --cask virtualbox 
```
```
brew install --cask vagrant
```
```
brew install --cask vagrant-manager
```

<br>

# Linux

### Tools Prerequisites for Centos 9, RHEL9 & Rocky Linux


**Installing Virtualbox**
- Open Terminal and execute below commands

```
sudo yum update
sudo yum install patch gcc kernel-headers kernel-devel make perl wget -y
sudo reboot
```

- Login, open terminal and execute below commands

```
sudo wget http://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -P /etc/yum.repos.d
sudo yum install VirtualBox-7.1 -y
```

**Installing Vagrant**
- Open Terminal and execute below commands

```
sudo dnf update -y
sudo dnf config-manager --add-repo=https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo dnf install vagrant -y
```

<br>

 ### Tools Prerequisites for Ubuntu 24
                                
**Install Virtualbox**

- Open Terminal and Execute below mentioned commands.

```
sudo apt update
sudo apt install curl wget gnupg2 lsb-release -y
```
```
curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc|sudo
gpg --dearmor -o /etc/apt/trusted.gpg.d/vbox.gpg
```
```
curl -fsSL https://www.virtualbox.org/download/oracle_vbox.asc|sudo gpg
--dearmor -o /etc/apt/trusted.gpg.d/oracle_vbox.gpg
```

```
echo "deb [arch=amd64]
http://download.virtualbox.org/virtualbox/debian jammy
contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
```

```
sudo apt update
sudo apt install -y linux-headers-$(uname -r) dkms
sudo apt install virtualbox-7.1 -y
sudo usermod -aG vboxusers $USER
newgrp vboxusers
```

**Install Vagrant**

- Open Terminal and Execute below mentioned commands.

```
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo
tee /usr/share/keyrings/hashicorp-archive-keyring.gpg 
```
``` 
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg]
https://apt.releases.hashicorp.com jammy main" | sudo tee
/etc/apt/sources.list.d/hashicorp.list
```
```
sudo apt update 
sudo apt install vagrant -y
sudo apt install libarchive-dev libarchive-tools -y
```
