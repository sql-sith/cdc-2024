# Setting a Proxy for Ubuntu Desktop

## Values

**PROXY:** `199.100.16.100:3128`  
**GATEWAY:** `144.76.90.254`  
**YOURSELF:** `144.76.90.???/24`

When we say `{YOU}`, please consult the team and come up with a unique number between 7 and 250 (inclusive) to put there.
> Please maintain a single `{YOU}` per server.

## Instructions

1. Open Settings>Network>Wired>Settings Icon
    1. Chose IPv4 tab
    2. For IPv4 Method, choose Manual
    3. Set Addresses>Address to 144.76.90.`{YOU}`
    4. Set Addresses>Netmask to 255.255.255.0
    5. Set Addresses>Gateway to 144.76.90.254
2. Settings>Network>Network Proxy>Settings Icon
    1. Choose Manual
    2. HTTP Proxy (Left box) 199.100.16.100
    3. HTTP Proxy (Right box): 3128
    4. HTTPS Proxy (Left box) 199.100.16.100
    5. HTTPS Proxy (Right box): 3128
    6. FTP Proxy (Left box) 199.100.16.100
    7. FTP Proxy (Right box): 3128
    8. Socks Host (Left box) 199.100.16.100
    9. Socks Host (Right box): 3128
3. Set `/etc/apt/apt.conf`'s contents to the following:
    ```
    Acquire::http::Proxy "http://199.100.16.100:3128";
    Acquire::https::Proxy "http://199.100.16.100:3128";
    ```
4. Restart the machine
5. `apt`, `curl` and `wget` should now be working.  
	Verify this by running the following:
	| Program to Test | Command to Run                           |
	|:---------------:|------------------------------------------|
	|      `apt`      | `sudo apt update && sudo apt upgrade -y` |
	|     `curl`      | `curl google.com`                        |
	|     `wget`      | `wget google.com`                        |
