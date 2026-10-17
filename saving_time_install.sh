#!/bin/bash

echo "Here go again, iniciando a instalação!"

sudo apt update && sudo apt update -y

echo "Pacotes atualizados com sucesso!"

# basico do basico para codar
echo "Instando o Git e o Neovim"

sudo apt install -y git nvim

echo "NeoVim instalado com sucesso"

# adicionando chaves e instalando o spotify

echo "Instalando o Spotify (afinal, não tem como trampar sem música)"

curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt-get update && sudo apt-get install spotify-client

# configurando o tema de pastas (apenas Linux Mint)

echo "Configurando o tema da interface de pastas"

dconf write /org/cinnamon/desktop/interface/icon-theme "'Mint-Y-Dark-Aqua'"

# instalando o tema do VSCode (Linuxzada Calm Dark)

if command -v code > /dev/null; then
    echo "Instalando o tema Linuxzada Calm Dark no VSCode"

    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    mkdir -p ~/.vscode/extensions
    cp -r "$SCRIPT_DIR/vscode-theme" ~/.vscode/extensions/linuxzada-calm-dark

    echo "Tema instalado! Selecione em Preferences: Color Theme"
fi

echo "Instalação concluída com sucesso"


