
function network_setup {

	echo "Configuring hostname..."
	raspi-config nonint do_hostname $hostname

	echo "Configuring network..."
	echo "# interfaces(5) file used by ifup(8) and ifdown(8)

# Please note that this file is written to be used with dhcpcd
# For static IP, consult /etc/dhcpcd.conf and 'man dhcpcd.conf'

# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d

auto lo
iface lo inet loopback

auto eth0
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
}


