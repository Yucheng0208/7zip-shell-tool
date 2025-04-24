# 7zip-shell-tool

A multilingual interactive `7-Zip` command-line tool written in Bash.  
Supports compression, extraction, and archive listing with persistent language settings.

## Features

- Compress folders/files to `.7z`, `.zip`, `.tar`, `.gz`, `.xz`
- Extract archives to the target directory
- List archive contents
- Selectable compression levels (store to ultra)
- Interactive language setup (English / 中文)
- Language preference is saved across sessions via `~/.7zconfig`
- Compatible with macOS and Linux

## Quick Start

```bash
chmod +x 7z-run.sh
./7z-run.sh

## LICENSE
This project is released under the [MIT License](LICENSE).
