#!/bin/bash
# <sven.kreienbrock@ruhr-uni-bochum.de>

DEBUG=0
OVERRIDE=0
ADDGPU=1
OS="not available"

# failcodes
# 10 - not root
# 20 - code run not allowed.

## System Information

## functions
check_root_access(){
if [[ $UID -ne 0 ]]; then
	echo "Sorry - You're not privileged enough to run this script."
	exit 10
fi
}

run_code () {
if test $OVERRIDE -eq 1; then
	sysupdate
	if [[ $(docker --version|wc -l) -eq 1 ]]; then 
		echo "You seem to have $(docker --version) installed."
	else
        	install_docker
	fi
else
	run_code_q
fi
}

run_code_q () {
# OVERRIDE is ON, run code and exit normally
if test $OVERRIDE -eq 1; then run_code; exit 0;fi
# OVERRIDE is OFF:
echo -ne "run code? (y/n) > "
read runcode
if [[ $runcode == 'y' ]] || [[ $runcode == 'Y' ]]; then
   let OVERRIDE=$OVERRIDE+1
   run_code
else
   # return fail code 20
   echo byebye
   exit 20
fi
}

sysinfo(){
	OS=$(cat /etc/os-release|grep "^NAME"|cut -d= -f2|tr -d '"')
	release=$(lsb_release -sd)
	echo "OS: " $OS "($release)"
}

sysupdate(){
	if [[ $OS == "Ubuntu" ]]; then
		apt-get -y -qq update
		apt-get -y -qq upgrade
		apt-get -y -qq install apt-transport-https ca-certificates curl software-properties-common
		apt-get -y -qq autoremove && apt-get clean
	else
		echo "Sorry - No Updates for other Systems than Ubuntu right now."
	fi
}

install_docker(){
case $OS in
	Ubuntu|Pop!_OS)
	VERSION=$(lsb_release -sr)
	case $VERSION in
		20.04)
		echo "INSTALL DOCKER for Ubuntu 20.04"
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
		add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
		apt update
		sudo apt -y install docker-ce
		;;
		22.04)
		echo "INSTALL DOCKER for Ubuntu 22.04"
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
		add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu jammy stable"
		apt update
		sudo apt -y install docker-ce
		## add nvidia-docker if 22.04 and ADDGPU=1
		if [[ $ADDGPU -eq 1 ]]; then add_nvidia_docker; fi
		;;
	esac
	;;
esac
}

add_nvidia_docker(){
	## missing checks for nvidia-docker 1 and removal of it, if it is installed.
	curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
	distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
	curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list
	sudo apt-get -y -qq update
	apt-get install nvidia-docker2
}

## MAIN
check_root_access
sysinfo
run_code_q
exit 0
