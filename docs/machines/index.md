# Overview of the 3 Homelab networks

## :material-network: LAN Network

### i5-8500T

- Proxmox
- Docker
- n8n
- ollama
- Open WebUI
- OpenClaw

### Raspberry Pi 3

- Home Assistant native since it has only 1 GB RAM

### Jetson Nano

- Docker
- llama.cpp in a container
- Wordpress

## :material-home: HOME Network

### Penta-GPU server

- Docker
  - ollama
  - traefik
  - openwebui on [llm.server.home](http://llm.server.home)
  - grafana [grafana.server.home](http://grafana.server.home)
  - Wordpress [wp.server.home](http://wp.server.home)
- Other stuff

### :material-raspberry-pi: Raspberry Pi 4 with 4 GB

- Pi-hole [pi4.hv.io.vn/admin](https://pi4.hv.io.vn/admin) with FQDN
- Home assistant [home assistant on pi.home](http://10.10.10.4:8123)
- **Pi-hole**: Acts as an AD blocker and DNS server. Approx. 25% of requests are blocked.
- **Home Assistant**: Connects to Bluetooth temperature and humidity sensors.
- **Automations**: Runs n8n at `n8n.hv.io.vn`.
