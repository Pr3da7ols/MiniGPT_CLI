#!/usr/bin/env bash
set -euo pipefail

OWNER="Pr3da7ols"
REPO="MiniGPT_CLI"
BRANCH="main"
PACKAGE="NexoIA-MiniGPT-Obfuscated-3.14.zip"
PACKAGE_URL="https://raw.githubusercontent.com/${OWNER}/${REPO}/${BRANCH}/${PACKAGE}"
INSTALL_DIR="${MINIGPT_OBFUSCATED_DIR:-$HOME/MiniGPT_CLI-Obfuscated-3.14}"

if ! command -v pkg >/dev/null 2>&1; then
    echo "Este instalador automático está preparado para Termux." >&2
    echo "En PC: extrae el ZIP y ejecuta install-remote.ps1 (Windows) o install-remote.sh (Linux/macOS)." >&2
    exit 2
fi

if [ -e "$INSTALL_DIR" ]; then
    echo "Ya existe $INSTALL_DIR. Para otra instalación, define MINIGPT_OBFUSCATED_DIR con una ruta nueva." >&2
    exit 2
fi

pkg install -y python unzip
if ! python3 -c 'import sys; raise SystemExit(0 if sys.version_info[:2] == (3, 14) else 1)'; then
    echo "La distribución requiere CPython 3.14.x." >&2
    exit 2
fi

INSTALL_TMP="$(mktemp -d "${TMPDIR:-$HOME}/nexoia-obfuscated.XXXXXX")"
cleanup() { rm -rf "$INSTALL_TMP"; }
trap cleanup EXIT INT TERM

curl -fsSL --retry 3 "$PACKAGE_URL" -o "$INSTALL_TMP/package.zip"
unzip -tq "$INSTALL_TMP/package.zip"
mkdir "$INSTALL_TMP/extracted"
unzip -q "$INSTALL_TMP/package.zip" -d "$INSTALL_TMP/extracted"
if [ ! -f "$INSTALL_TMP/extracted/pyproject.toml" ] || [ ! -f "$INSTALL_TMP/extracted/install.sh" ]; then
    echo "El ZIP descargado no contiene el paquete esperado." >&2
    exit 2
fi

mkdir -p "$(dirname -- "$INSTALL_DIR")"
mv "$INSTALL_TMP/extracted" "$INSTALL_DIR"
bash "$INSTALL_DIR/install.sh"
