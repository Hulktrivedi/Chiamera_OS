# 🧬 Chimera OS

Chimera OS is a modular, secure, and highly customizable Linux-based operating system that allows users to switch between UX styles (Windows-like, macOS-like, or pure Linux) and enjoy a flexible virtual filesystem layout.

> ⚠️ This project is under active development. Features and design are subject to change.

---

## 🌟 Key Features

- **Switchable UX Environments**: Select between Windows-style, macOS-style, or native Linux-like user experience.
- **Doomsday Protocol (DPP)**: An isolated, self-healing recovery and ransomware-protection layer.
- **Soft Partitioning**: Virtual drive layout mimicking familiar OS designs — D:, E: or /Volumes/Data — while keeping the system secure.
- **Installer with Flexibility**: Choose install sizes, UX preferences, and filesystem layout during setup.
- **Modular Sandbox Environment**: Run untrusted apps in isolated containers.
- **Live ISO Support**: Boot, test, and install the OS from a custom-built ISO.

---

## 🖥️ System Requirements

Here are the minimum and recommended hardware specs to run Chimera OS smoothly:

| Component       | Minimum Specs                          | Recommended Specs                        |
|----------------|----------------------------------------|------------------------------------------|
| CPU            | Dual-core 64-bit                       | Intel i5/i7 (8th Gen+) or AMD Ryzen 5+   |
| RAM            | 4 GB                                   | 8–16 GB or more                          |
| Disk           | 32 GB SSD                              | 128+ GB NVMe SSD                         |
| GPU            | Intel HD Graphics                      | Dedicated GPU (NVIDIA/AMD)               |
| Boot Mode      | UEFI with Secure Boot OFF              | UEFI (with optional Secure Boot support) |
| Miscellaneous  | Internet connection (for updates)      | Ethernet/Wi-Fi                          |

> 💡 **Note:** The Doomsday Protocol (DPP) requires an additional ~4GB of isolated space and runs best on SSDs.

---

## 📦 Folder Structure Overview

Project_ChimaeraOS/  
├── iso/ # Core ISO building files  
├── dpp/ # Doomsday Protocol tools  
├── scripts/ # Automation & install scripts  
├── config/ # UX style configs  
├── install/ # Hard & soft partitioning logic  
├── docs/ # Developer docs & roadmap  
├── .vscode/ # Preconfigured VSCode workspace  
└── README.md # You are here  