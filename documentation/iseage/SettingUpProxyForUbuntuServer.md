# Connecting to the outside world from ISEAGE

> Created by Aksel Rasmussen on 2023-10-14
> Last updated by Aksel Rasmussen on 2024-02-21 at 14:43

> NOTE: These instructions are for use with an unmodified install of Ubuntu Server.
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
3) Add the following lines to the end of `/etc/profile`:
	```sh
	export http_proxy=http://199.100.16.100:3128
	export https_proxy=http://199.100.16.100:3128
	export ftp_proxy=http://199.100.16.100:3128
	```
4) Set `/etc/apt/apt.conf`'s contents to the following:
	```
	Acquire::http::Proxy "http://199.100.16.100:3128";
	Acquire::https::Proxy "http://199.100.16.100:3128";
	```
5) Run `sudo netplan apply`
6) Append the following to `/etc/wgetrc`:
	```
	use_proxy=yes
	http_proxy=199.100.16.100:3128
	https_proxy=199.100.16.100:3128
	```
7) Restart the machine
8) `apt`, `curl` and `wget` should now be working.  
	Verify this by running the following:
	| Program to Test | Command to Run                           |
	|:---------------:|------------------------------------------|
	|      `apt`      | `sudo apt update && sudo apt upgrade -y` |
	|     `curl`      | `curl google.com`                        |
	|     `wget`      | `wget google.com`                        |

> Currently known issues:
> - `dig` isn't working
> - `nslookup` isn't working
> - `named` can't forward its requests
