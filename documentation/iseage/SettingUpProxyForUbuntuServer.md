# Connecting to the outside world from ISEAGE

> Instructions written by Aksel Rasmussen on 2023-10-14
> Last updated by Aksel Rasmussen on 2023-10-21

> NOTE: These instructions are for use with a fresh ubuntu server with no modifications.
> If you have any issues outside of that, that's your fault.

1) Open `/etc/netplan/00-installer-config.yml`
2) Change what `ethernets:{yourEthernet}` says to:
	```
	{your ethernet}:
	  dhcp4: no
	  addresses: [144.76.90.{num}/24]
	  routes:
	   - to: default
	     via: 144.76.90.254
	  nameservers:
	    addresses: [144.76.90.254]
	```
	> Replace `{num}` with a unique number from `1` to `253`.
3) Exit the file.
4) Add the following lines to the end of `/etc/profile`:
	```sh
	export http_proxy=http://199.100.16.100:3128
	export https_proxy=http://199.100.16.100:3128
	export ftp_proxy=http://199.100.16.100:3128
	```
5) Set `/etc/apt/apt.conf`'s contents to the following:
	```
	Acquire::http::Proxy "http://199.100.16.100:3128";
	Acquire::https::Proxy "http://199.100.16.100:3128";
	```
6) Run `sudo netplan apply`
7) Restart the machine
8) Verify everything is working by running `sudo apt update`.
