#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

OWNER="Pr3da7ols"
REPO="MiniGPT_CLI"
BRANCH="main"
REPO_URL="https://github.com/${OWNER}/${REPO}.git"
INSTALL_DIR="$HOME/MiniGPT_CLI"
VENV_DIR="$HOME/.venvs/minigpt"

if ! command -v pkg >/dev/null 2>&1; then
    echo "Este instalador está preparado para Termux." >&2
    exit 2
fi

pkg update -y
pkg install -y git python

if [ -d "$INSTALL_DIR/.git" ]; then
    git -C "$INSTALL_DIR" pull --ff-only
elif [ -f "$INSTALL_DIR/pyproject.toml" ]; then
    echo "Usaré el código MiniGPT que ya está en $INSTALL_DIR."
elif [ -e "$INSTALL_DIR" ]; then
    echo "Ya existe $INSTALL_DIR y no parece un repo MiniGPT; muévelo o cambia INSTALL_DIR." >&2
    exit 2
else
    git clone --branch "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
fi

python -m venv "$VENV_DIR"
# shellcheck disable=SC1091
. "$VENV_DIR/bin/activate"
python -m pip install --upgrade pip
cd "$INSTALL_DIR"
python -m pip install -e '.[terminal]'

mkdir -p "$HOME/.mini_gpt"
if [ ! -f "$HOME/.mini_gpt/.env" ] && [ -f "$INSTALL_DIR/mini_gpt/.env.example" ]; then
    cp "$INSTALL_DIR/mini_gpt/.env.example" "$HOME/.mini_gpt/.env"
    chmod 600 "$HOME/.mini_gpt/.env"
fi

printf '\nMiniGPT CLI quedó instalado en %s\n' "$VENV_DIR"
printf 'Comando: %s/bin/mini-gpt\n' "$VENV_DIR"
printf 'Configura el relay en: %s/.mini_gpt/.env\n' "$HOME"
printf 'No subas ese .env a GitHub.\n'
