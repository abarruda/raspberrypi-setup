#!/bin/bash
set -e

source docker/docker.sh
source docker/docker-compose.sh
source network/network.sh

echo "Specify hostname:"
read hostname
echo "Specify IP address:"
read ip

echo "Is the following correct? (typing yes proceeds)"
echo "Hostname: $hostname"
echo "IP address: $ip"
read continue

if [ "$continue" == "yes" ]
then
	echo "Updating firmware..."
	rpi-update

	echo "Reducing GPU memory to 16MB..."
	sudo raspi-config nonint do_memory_split 16

	export LANGUAGE=en_US.UTF-8
	export LANG=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
	echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
	locale-gen

	TIMEZONE="America/Los_Angeles"
	echo $TIMEZONE > /etc/timezone  
	cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
	
	apt-get update;
	apt-get -y upgrade;
	apt-get -y install screen vim git;
	apt-get autoremove;
	apt-get autoclean;

	network_setup
	
	docker_install
	docker_compose_install

	echo "A reboot is strongly suggested."
fi

