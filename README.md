# Chimera Linux

Chimera Linux is a flexible, modular, and security-centric Linux distribution designed to be user-configurable from the ground up. Inspired by Windows, macOS, and penetration testing distros like Kali, Chimera offers:

- Easy UI/UX for general users
- Deep system configurability for power users
- Pen-testing and development toolkit
- Security-first sandboxing and isolation
- A powerful Doomsday Protocol (DPP) recovery environment

## Features
- Sandbox for internet downloads and untrusted apps
- Built-in support for .exe and macOS-style app formats
- Modular partitioning for system, user data, and secure recovery (DPP)
- Optional cloud vault for backups and encryption safety

## Architecture
- `iso/base`: Core system and pre-installed apps
- `dpp/`: Encrypted recovery partition, includes repair, restore, decrypt tools
- `scripts/`: System installers, ISO builders, sandbox runners
- `config/`: Config files for custom builds
- `docs/`: Developer & contribution guides

## Build Instructions
Coming soon! You will need:
- Linux host (Ubuntu/Fedora preferred)
- `build-iso.sh` to generate ISO
- Docker (for sandboxing and isolated tools)

## License
MIT License / BSD / GPL (TBD)

---

> ⚠️ This project is in early development. Many features are being actively built.
> Feel free to explore, suggest, contribute, or just keep an eye on progress!
