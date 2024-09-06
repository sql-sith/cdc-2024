# Linux server checklist

- Check server version:

    ```bash
    cat /etc/*release*
    ```

- Check IP address

    ```bash
    ip addr
    ```

- Get a new DHCP address (if you've changed networks)

    ```bash
    dhclient -d # use ctrl-c to exit after the address is issued
    ```

- Check for listening ports

    ```bash
    # when using (E)xtended regex, \b means "word boundary":
    netstat -an | grep -E '\bLISTEN\b'
    # or
    lsof -i -nP | grep '(LISTEN)'

- Scanning code with Semgrep OSS Code
  - See https://github.com/semgrep/semgrep

    ```bash
    python3 -m pip install semgrep
    ```

- Initial port discovery
