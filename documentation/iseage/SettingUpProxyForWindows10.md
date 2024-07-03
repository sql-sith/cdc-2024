# Windows 10 Proxy Settings

A guide for setting up Windows 10 on Iserink with internet.

> ### !!WARNING!!
> DO NOT give Windows internet access until setup is complete, or it will give you a worse experiance.
> NOBODY IN THEIR RIGHT MIND wants a worse experiance.
> Please DON'T let windows kill you.
> PLEASE.

> ### A Quick note before we begin
> Wish we were younger.
> This guide is based on Win10.
> It may work with Win11 and 12, but I don't care.
> It is also based on a fresh install.
> If it doesn't work on your machine, it works on mine, so get over it.
> If you feel like reinstalling windows will make it work better, than do that.

## Setup

1. Navigate: Settings > Network & Internet > Ethernet.
2. Click the network. It should be called somthing like "Unidetified network".
3. Under "IP settings", press the "Edit" button.
4. In the dialog that pops up, change the dropdown from "Automatic (DHCP)" to "Manual".
5. Turn on the "IPv4" switch.
6. Set "IP address" to a free address in the form "144.76.90.*". Check with the team for which addresses are available.
7. Set "Subnet prefix length" to "24".
8. Set "Gateway" to "144.76.90.254".
9. Ignore the DNS boxes and press the "Save button".
10. Navigate: Settings > Network & Internet > Proxy.
11. Under "Automatic proxy setup", turn off "Automatically detect settings".
12. Under "Manual proxy setup", turn on "Use a proxy server".
13. Set "Address" to "199.100.16.100".
14. Set "Port" to "3128".
15. Press the "Save" button.

## Verifying the Proxy

1. In a webbrowser, go to your favourite external website. (eg. not google)
2. If it loads, you got it.
3. If it doesn't load, that's your problem. Go reread the guide, esp the top part.
