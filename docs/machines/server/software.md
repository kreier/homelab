# :material-auto-fix: server.home - Software

The system runs on **Ubuntu 24.04 LTS** with support (ESM) until 2034.

## :material-monitor-dashboard: Monitoring & UI

We use `nvtop` to monitor the load across all three GPUs and **Open WebUI** as the primary interface for LLM interaction.

![nvtop Monitor](../../assets/2026-01-27nvtop.jpeg)
*Real-time monitoring of the 3x GPU cluster.*

![Open WebUI Interface](../../assets/2026-01-27openWebUI.jpeg)
*Custom Open WebUI instance running locally.*

## :material-docker: Service Stack
* **Traefik**: Handles domain names and SSL for `*.server.home`.
* **Ollama**: Backbone for local LLMs accessed via Open WebUI and n8n.
* **WordPress**: Multiple test installations including `hofkoh.server.home`.

!!! success ":material-file-certificate: SSL Security"
    Once the root certificate is imported, all subdomains are trusted, and local traffic is fully encrypted.
