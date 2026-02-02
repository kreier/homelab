# Homeserver

![GitHub License](https://img.shields.io/github/license/kreier/homeserver)
![GitHub Release](https://img.shields.io/github/v/release/kreier/homeserver)

Documentation on my journey to a little homelab.

## server.home

This machine runs only when started manually, and is switched off most of the time. It's more a playground to see what's possible with local LLMs due to its 3 GPUs and 22 GB of fast VRAM. Other specifications:

- Intel [i3-6100](https://www.intel.com/content/www/us/en/products/sku/90729/intel-core-i36100-processor-3m-cache-3-70-ghz/specifications.html) 2C/4T 3.7 GHz Skylake
- EVGA [Z170 Classified](https://www.evga.com/support/manuals/files/151-SS-E179.pdf) motherboard with Quad-SLI, 6 PCIe slots
- RAM: 32 GB DDR4 2400 (early 2026 reduced to 16 GB)
- GPU: all NVIDIA
  - P104-100 8GB GDDR5X [314 GB/s](https://kreier.github.io/benchmark/gpu/opencl/) 5005 MHz
  - GTX 1070 8GB GDDR5  [220 GB/s](https://kreier.github.io/benchmark/gpu/) 3802 MHz
  - P104-100 6GB GDDR5  [176 GB/s](https://kreier.github.io/benchmark/gpu/opencl/) 4006 MHz
- NVMe: 256 Toshiba PCIe 4.0 x4
- SSD: 240 Kingston SATA3 for the models of LLM used by Ollama

![nvtop 3x GPU](docs/2026-01-27nvtop.jpeg)

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
 
Over SSH I can see some details with btop and nvtop about the systems stage. And OpenWebUI renders a beautiful LLM interface that allows to upload documents and rendered LaTeX output, structured text and tables

![OpenWebUI output](docs/2026-01-27openWebUI.jpeg)

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

## pi4.home for home automation and DNS

Just with the router from Asus it's not possible to have subdomains for the server to access the different services. Traefik is forwarding incoming requests to the right container, but getting a DNS entry is another question. With Pihole I also get a great AD blocker. Its surprizing that about 25% of all DNS requests have to be blocked!

