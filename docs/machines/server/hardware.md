# :material-server: Penta-GPU server - Hardware

This machine is a playground for local LLMs, utilizing 4 GPUs to achieve 30 GB of fast VRAM.

## :material-view-quilt: Physical Build

![ServerFront](../../assets/2026-02-19_inside.jpg){ width="40.8%" } ![ServerInternal](../../assets/2026-02-19_ollama_nemotron2.png){ width="58.5%" }
*Left: Four GPUs next to one another. Right: Stats from `nvtop`. Click to enlarge.*

## :material-cog-outline: Specifications

| Component | Detail |
| :--- | :--- |
| :material-cpu-64-bit: **CPU** | Intel i3-6100 (2C/4T @ 3.7 GHz Skylake) |
| :material-anvil: **MB** | EVGA Z170 Classified 4-way |
| :simple-nvidia: **GPUs** | Four Pascal-GPUs (Compute Capability 6.1) |
| :material-memory: **RAM** | 16 GB DDR4 2400 (Early 2026 reduced from 32 GB) |
| :material-harddisk: **Storage** | 256GB NVMe + 240GB SATA SSD for Ollama |

![EVGA Z170](../../assets/2026-02-02z170classified.jpg)
*The EVGA Z170 Classified motherboard supporting 4-way GPU configurations.*


## :material-history: Historic Graphics Cluster (Early 2025)

Before the current optimization, the system ran a 4-GPU cluster to maximize VRAM availability.

| GPU Model | VRAM | Connection | Bandwidth |
| :--- | :--- | :--- | :--- |
| **RTX 3060 Ti** | 8 GB GDDR6 | PCIe 3.0 x16 | 448 GB/s |
| **P106-100** | 6 GB GDDR5 | PCIe 3.0 x8 | 192 GB/s |
| **P106-100** | 6 GB GDDR5 | PCIe 3.0 x4 | 192 GB/s |
| **GTX 1060** | 6 GB GDDR5 | **PCIe 1.0 x1** | 192 GB/s |

!!! warning "The PCIe 1.0 x1 Bottleneck"
    The fourth card (GTX 1060) was connected via a PCIe 1.0 x1 slot. While this provided an additional 6 GB of VRAM allowing larger models to load, the extremely narrow bus (0.25 GB/s) created significant latency when the model's KV Cache or weights needed to transit that specific card.

## :material-memory: Current Graphics Cluster (2026)

The current setup focuses on balancing thermal overhead and consistent VRAM speeds:

1.  **P104-100 (8GB GDDR5X)**: :material-speedometer: 314 GB/s
2.  **GTX 1070 (8GB GDDR5)**:  :material-speedometer: 220 GB/s
3.  **P104-100 (8GB GDDR5X)**: :material-speedometer: 314 GB/s
4.  **P106-100 (6GB GDDR5)**:  :material-speedometer: 176 GB/s

All 56 layers of the nemotron-3-mini 31B parameter network are in VRAM for a fast 40 t/s inference! The GPUs report 184 + 43 + 42 + 170 = **439 Watt**. On average from the wall it was actually 420 Watt for the whole system. VRAM: `ollama ps` reported **26 GByte**, here are 6.4 + 6.7 + 5.4 + 6.8 = 25.3 GB plus some KV cache.

![nvtop output 2026-02](../../assets/2026-02-19_ollama_nemotron2.png)

Earlier in January 2026 with just 3 GPUs: This rocks! All 47 layers in the GPUs, each with 1 GB space for local K-V values. 137 Watt, 18.9 GB.

![nvtop output 2026-01](../../assets/2026-01-27nvtop.jpeg)

## History

### Early 2025 - 26 GB, quad-GPU with riser

- RTX 3060 Ti 8GB
- GTX 1060 6GB
- P106-100 6GB
- P106-100 6GB

![Server Front](../../assets/2025-01_server.jpg){ width="59.2%" } ![Server Internal](../../assets/2025-01_server_display.jpg){ width="39.3%" }

### Early 2026 - 22 GB, triple-GPU

- P104-100 8GB
- GTX 1070 8GB
- P106-100 6GB

### February 2026 - 30 GB, quad-GPU without riser

- P104-100 8GB regular
- P104-100 8GB custom cooler and dual-fan
- GTX 1070 8GB
- P106-100 6GB
