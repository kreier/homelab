# :material-home-automation: Welcome to the Kreier Homelab

![GitHub License](https://img.shields.io/github/license/kreier/homeserver)
![GitHub Release](https://img.shields.io/github/v/release/kreier/homeserver)

This is a documentation on my homelab projects. The setup currently consists of 

- :material-router: 3 routers,
- :material-switch: 1 managed switch,
- :material-server: 3 always-on servers, and
- :material-brain: two LLM servers for ollama, n8n, openClaw and open WebUI.

!!! info "Current Status"
    The lab features a combined 30 GB of GDDR5/X VRAM for local LLM inference and a dedicated Proxmox node for high-availability services.

## :material-layers-outline: Infrastructure at a Glance

### LAN Network

* **[:material-lan: Raspberry Pi 3](./machines/pi3.md)**: Secondary network management.
* **[:material-chip: i5-8500T](./machines/8500/hardware.md)**: The energy-efficient HP EliteDesk mini (4W idle).
* **[Jetson Nano 4GB](./machines/jetson/hardware.md)**: Accelerated workload with GPU and GbE network.

### :material-home-automation: HOME Network

* **[:material-server-network: Penta-GPU server](./machines/server/hardware.md)**: The LLM playground with quad NVIDIA GPUs.
* **[:material-raspberry-pi: Raspberry Pi 4](./machines/pi4.md)**: Network backbone for Home Assistant and DNS.

![ServerFront](./assets/2026-02-19_inside.jpg){ width="40.8%" } ![ServerInternal](./assets/2026-02-19_ollama_nemotron2.png){ width="58.5%" }
*Left: 2026-02 Quad-Nvidia GPU. Right: Stats from `nvtop` for the Penta-GPU server in the terminal.*

## :material-server-network: Quick Links

- **[:material-tools: Setup Guide](./setup.md)**: Configuration and Docker basics.
- **[:material-server: Penta-GPU server](./machines/server/hardware.md)**: Details on the 30GB VRAM LLM cluster.
- **[:material-chip: i5-8500](./machines/8500/hardware.md)**: Proxmox and agentic AI. The energy-efficient Proxmox node.
- **[:material-history: History](./history.md)**: Benchmarks and the evolution of the lab.

---
### Current Lab Architecture

!!! info "Navigation Tip"
    In the sidebar to the left, click on **Servers** to expand the specific details for the `Penta-GPU server` and `i5-8500T`.

## History

In early 2025 a prototype of the Penta-GPU server was running with a Gen1 x1 riser card and two weaker 6GB cards as a proof of concept. The LLMs were accessed in the terminal via ollama, no Open WebUI yet.

![Server Front](./assets/2025-01_server.jpg){ width="59.2%" } ![Server Internal](./assets/2025-01_server_display.jpg){ width="39.3%" }
*Left: The setup early 2025 with a GTX 960 on a riser card. Right: Ollama output and stats from `nvtop` in the terminal.*
