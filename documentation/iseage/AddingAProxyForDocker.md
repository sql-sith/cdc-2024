# Adding A Proxy For Docker
In this document we will cover setting up docker to work though the WiErd and StrAnge iseage proxy.

## Method 1: use systemd

1) Create a config folder (root):
	```sh
 	mkdir -p /etc/systemd/system/docker.service.d
 	```
 2) Create a proxy config (root):
	```sh
 	touch /etc/systemd/system/docker.service.d/http-proxy.conf
 	```
 3) Add the proxy info to the above file (root):  
	(Add these lines to it:)
	```ini
 	[Service]
	Environment="HTTP_PROXY=http://199.100.16.100:3128"
	Environment="HTTPS_PROXY=http://199.100.16.100:3128"
	Environment="NO_PROXY=localhost,127.0.0.1"
 	```
 4) Restart docker (root):
	```sh
 	systemctl daemon-reload
	systemctl restart docker
 	```
 5) Make sure everything is working:
	```sh
 	docker info | grep Proxy
 	```
 	If this matches the text in step 3 well enough, we are done.
	If not, this incident will be reported.

## Method 2: add some docker config

1) Open `~/.docker/config.json`
2) Make sure the following structure is in the file:
	```json
	{
	 "proxies": {
	   "default": {
	     "httpProxy": "http://199.100.16.100:3128",
	     "httpsProxy": "http://199.100.16.100:3128",
	     "noProxy": "localhost,127.0.0.1,docker-registry.example.com,.corp"
	   }
	 }
	}
	```
 3) Hope it works.
