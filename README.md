# Corellium VPN Proxify

## What's This?

This repo turns Corellium's OpenVPN into several services on different ports

- A socks5 proxy
- A TCP forward manager with webui
  - By default, ssh, lldb, console, usbmuxd are forwarded

## Usage

Simply put your ovpn file named as 'config.ovpn' into this repo, and run `docker-compose up -d`

Then these service will be available on these ports:
- 15000: usbmuxd forwarded, uses socat or usbfluxd to turn it into local usbmuxd
- 15010: TCP forward manager webui, access this in your browser
- 15011: Socks proxy exposed from Corellium's VPN
- 15100: Device's SSH (Forwarded to 10.11.1.1:22)
- 15101: Device's lldb (Forwarded to 10.11.1.1:4000)
- 15102: Device's console (Forwarded to 10.11.1.1:2000)

Feel free to add more ports ;)