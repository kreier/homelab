# Homeserver

![GitHub License](https://img.shields.io/github/license/kreier/homeserver)
![GitHub Release](https://img.shields.io/github/v/release/kreier/homeserver)

Documentation on my journey to a little homelab.

## server.home

This machine runs only when started manually, and is switched off most of the time. It's more a playground to see what's possible with local LLMs due to its 3 GPUs and 22 GB of fast VRAM. Other specifications:

- i3-6100
- EVGA Z170 Confidential motherboard with Quad-SLI
- RAM: 32 GB DDR4 2400 (early 2026 reduced to 16 GB)
- GPU: all NVIDIA
  - GTX 1070 8GB GDDR5
  - P104-100 8GB GDDR5
- NVMe: 256 Toshiba PCIe 4.0 x4
- SSD: 240 Kingston SATA3 for the models of LLM used by Ollama

### Software

As stable foundation until April 2029, and with Ubuntu Pro (ESM) until April 2034 this should be enough time to just keep this system running. Almost all other modules run in a docker container. With a fixed IP 10.10.10.40 the services get their own subdomains of server.home. It is routed with a Raspberry Pi 1B in the same network, using pihole.

- **traefik** to handle the domain names and access from the web
- **wordpress** under wp.server.home as a test wordpress installation
- **ollama** as the backbone for the llms being accessed over Open WebUI and n8n
- **Open WebUI** is accessed via llm.server.home
- **Grafana** creates beautiful visuals of the use of the server
- **n8n** tries to automate some workflows and use open APIs and LLMs in the process
- Further wordpress installations:
  - hofkoh.server.home to have an image of the old **hofkoh.de**
  - saihtorg.server.home to have an image of the old **saiht.org**
 
Over SSH I can see some details with btop and nvtop about the systems stage.

### Docker

I was surprizes how simple the setup with docker is. Inside your home folder you create a folder `/docker` and for each container a subfolder, for example `~/docker/wordpress`. Then you put a YAML `docker-compose.yml` file in there that describes services (db, wordpress), volumes and networks. For a first start you need

``` sh
docker compose up -d
docker compose down
docker restart traefik
``` 

You can also forward instructions into the docker container, or open a console in it:

``` sh
docker exec -it ollama ollama run mistral --verbose
docker exec -it ollama bash
```

Don't forget to create your network:

```sh
docker network create my_network
docker network ls
```


### Traefik and SSL/TLS

Now I have a root certificate for server.home. Once it is imported, all the other sites as subdomains are trusted with the wildcard *.server.home certificate. All network traffic even inside the local network is therefore encrypted.

Link to certificate: 

## 8500.home

Technically it is an i5-8500T processor inside the HP EliteDesk mini 800 G4 with 2 NVMe slots inside. The motivation was not just size, but the power consumption of just 4 Watt when idle. And homeservers are idle most of the time, why waste a lot of electricity. It has a separate network and is actually connected to the internet to n8n.io.vn or c103.io.vn

### Hardware

- i5-8500T
- NVMe PCIe 4.0 x4 512 GB
- USB Network 2.5 GB
