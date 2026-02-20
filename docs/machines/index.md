# Overview of the 3 Homelab networks

## :material-network: LAN Network

### i5-8500T

- Proxmox
- Docker
  - n8n
  - ollama
  - Open WebUI
  - OpenClaw
  - OPNSense

### Raspberry Pi 3

- Home Assistant [native](http://10.1.1.3:8123) since it has only 1 GB RAM

### Jetson Nano with 4 GB RAM

- Docker
- llama.cpp in a container
- Wordpress

### Rockchip rk3229

Only 1 GB RAM but Armbian is working.

- Docker

## :material-home: HOME Network

### Penta-GPU server

- Docker
  - Open WebUI on [llm.server.home](https://llm.server.home)
  - Wordpress [wp.server.home](https://wp.server.home)
  - hofkoh mirror [hofkoh.server.home](https://hofkoh.server.home/)
  - grafana [grafana.server.home](https://grafana.server.home)
  - n8n [n8n.server.home](https://n8n.server.home)
  - ollama
  - traefik
- Other stuff

### :material-raspberry-pi: Raspberry Pi 4 with 4 GB

- Docker
  - Pi-hole [pi4.hv.io.vn/admin](https://pi4.hv.io.vn/admin) with FQDN as DNS server and Ad blocker.
  - Home assistant [home assistant on pi.home](http://10.10.10.4:8123)
  - Wordpress [wp.pi4.hv.io.vn](https://wp.pi4.hv.io.vn/)
  - Automations [n8n.hv.io.vn](https://n8n.hv.io.vn)
  - OpenClaw [oc.hv.io.vn](https://github.com/openclaw/openclaw) this might take some time
- iperf3 -s
- btop

### :material-power-socket-eu: Tuya Smart Plug

Registered January 2026, therefore managed by the Singapore `sg` server, not Arizona `az` like my older sockets.

- Protocol 3.5 (AES-GCM (Galois/Counter Mode) Encryption instead of AES)
- [TinyTuya](https://pypi.org/project/tinytuya/) 1.17.4 supports 3.5
- [localtuya](https://github.com/rospogrigio/localtuya) 5.2.5 is only up to 3.4 and servers eu, us, cn and in endpoints (Frankfurt, Oregon, Shanghai and Mumbai)
- Missing: ueaz, weaz and sg (Virginia, Eemshaven and Singapore)
- [ProperGoodTuya](https://github.com/ClermontDigital/ProperGoodTuya) 5.4.0 supports 3.5 but is only 2 weeks old
- [hass-localtuya](https://github.com/xZetsubou/hass-localtuya/) 

Currently I can't connect to this 10.10.10.41 device. Works over the cloud.

### Raspberry Pico W

The idea was to use this 10.10.10.19 device with CircuitPython 10.1.1 as a wakeup button for the Penta-GPU server. The WOL on the server does not work, on neither of the i210 and i219 GbE ports. But the Pico W needs too much power that the Z170 mainmoard does not provide when suspended to S3.
