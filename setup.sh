#!/bin/bash
set -e

source docker-compose.sh

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

	raspi-config nonint do_hostname $hostname

	echo "# interfaces(5) file used by ifup(8) and ifdown(8)

# Please note that this file is written to be used with dhcpcd
# For static IP, consult /etc/dhcpcd.conf and 'man dhcpcd.conf'

# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d

auto lo
iface lo inet loopback

iface eth0 inet static
	address $ip
	netmask 255.255.255.0
	gateway 192.168.1.1

allow-hotplug wlan0
iface wlan0 inet manual
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

allow-hotplug wlan1
iface wlan1 inet manual
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf" > /etc/network/interfaces

	echo "Disable the DHCP client daemon and switch to standard Debian networking..."
	systemctl disable dhcpcd
	systemctl enable networking

	echo "Installing Docker"
	curl -sSL https://get.docker.com | sh;

	docker_compose_install
fi

