#!/bin/bash

# pasta onde o script está (para achar o tema do VSCode)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Nerd Fonts que serão instaladas (nomes iguais aos arquivos de https://github.com/ryanoasis/nerd-fonts/releases)
# opcionais: "Meslo" (a do powerlevel10k, ~135 MB) e "Iosevka" (~90 MB só de download)
NERD_FONTS=(JetBrainsMono FiraCode Hack CascadiaCode GeistMono)

# guarda o que deu errado para mostrar no final, sem parar o resto da instalação
FALHAS=()

falhou() {
    echo "Ops, deu ruim em: $1"
    FALHAS+=("$1")
}

echo "Here go again, iniciando a instalação!"

# remove o repositório apt antigo do Spotify (de versões anteriores deste script), senão a chave vencida quebra o apt update
if [ -f /etc/apt/sources.list.d/spotify.list ]; then
    sudo rm -f /etc/apt/sources.list.d/spotify.list /etc/apt/trusted.gpg.d/spotify.gpg
fi

sudo apt update && sudo apt upgrade -y

echo "Pacotes atualizados com sucesso!"

# basico do basico para codar (e o que o resto do script precisa)
echo "Instalando o Git, o Neovim e as ferramentas básicas"

sudo apt install -y git neovim curl wget gpg tar xz-utils fontconfig flatpak || falhou "pacotes básicos"

echo "Básico instalado com sucesso"

# flathub, de onde vem o Spotify e o Bitwarden

echo "Configurando o Flathub"

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || falhou "Flathub"

# instalando o spotify
# via Flatpak porque a chave do repositório apt do Spotify muda toda hora e quebra o apt update

echo "Instalando o Spotify (afinal, não tem como trampar sem música)"

sudo flatpak install -y --noninteractive flathub com.spotify.Client || falhou "Spotify"

# instalando o bitwarden (pacote oficial do Bitwarden no Flathub)

echo "Instalando o Bitwarden (senha forte só se for guardada em algum lugar)"

sudo flatpak install -y --noninteractive flathub com.bitwarden.desktop || falhou "Bitwarden"

# instalando o uv (gerenciador de pacotes e versões do Python)

echo "Instalando o uv"

if command -v uv > /dev/null || [ -x "$HOME/.local/bin/uv" ]; then
    echo "uv já está instalado, pulando"
else
    curl -LsSf https://astral.sh/uv/install.sh | sh || falhou "uv"
fi

# instalando as fontes para ricing

echo "Instalando as Nerd Fonts: ${NERD_FONTS[*]}"

FONT_DIR="$HOME/.local/share/fonts/NerdFonts"
mkdir -p "$FONT_DIR"

for font in "${NERD_FONTS[@]}"; do
    if [ -d "$FONT_DIR/$font" ]; then
        echo "$font já está instalada, pulando"
        continue
    fi

    mkdir -p "$FONT_DIR/$font"
    if ! curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.tar.xz" | tar -xJ -C "$FONT_DIR/$font"; then
        rm -rf "${FONT_DIR:?}/$font"
        falhou "fonte $font"
        continue
    fi

    # tira as variantes Propo (proporcional) e NL (sem ligaduras) que quase ninguém usa e ocupam metade do espaço
    find "$FONT_DIR/$font" -type f \( -name '*Propo*' -o -name '*NLNerdFont*' \) -delete
done

# ícones, emojis e uma fonte bonita para a interface
sudo apt install -y fonts-inter fonts-noto-color-emoji fonts-font-awesome || falhou "fontes do apt"

fc-cache -f > /dev/null

echo "Fontes instaladas com sucesso"

# instalando o VSCode pelo repositório oficial da Microsoft

if ! command -v code > /dev/null; then
    echo "Instalando o VSCode"

    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft.gpg > /dev/null
    printf "Types: deb\nURIs: https://packages.microsoft.com/repos/code\nSuites: stable\nComponents: main\nArchitectures: amd64,arm64,armhf\nSigned-By: /usr/share/keyrings/microsoft.gpg\n" | sudo tee /etc/apt/sources.list.d/vscode.sources > /dev/null

    { sudo apt update && sudo apt install -y code; } || falhou "VSCode"
fi

# instalando o tema do VSCode (Anti-Blind Theme)

if command -v code > /dev/null; then
    echo "Instalando o Anti-Blind Theme no VSCode"

    mkdir -p ~/.vscode/extensions
    rm -rf ~/.vscode/extensions/anti-blind-theme
    cp -r "$SCRIPT_DIR/vscode-theme" ~/.vscode/extensions/anti-blind-theme

    # só cria o settings.json se ainda não existir, para não apagar as configs de ninguém
    VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"
    if [ ! -f "$VSCODE_SETTINGS" ]; then
        mkdir -p "$(dirname "$VSCODE_SETTINGS")"
        cat > "$VSCODE_SETTINGS" <<'EOF'
{
  "workbench.colorTheme": "Anti-Blind Theme",
  "editor.fontFamily": "'JetBrainsMono Nerd Font', 'FiraCode Nerd Font', monospace",
  "editor.fontLigatures": true,
  "editor.fontSize": 15,
  "editor.lineHeight": 1.6,
  "editor.cursorBlinking": "solid",
  "terminal.integrated.fontFamily": "'JetBrainsMono Nerd Font'"
}
EOF
        echo "Tema e fonte já configurados no VSCode!"
    else
        echo "Tema instalado! Selecione em Preferences: Color Theme"
    fi
fi

# configurando o tema de pastas (apenas Linux Mint)

echo "Configurando o tema da interface de pastas"

dconf write /org/cinnamon/desktop/interface/icon-theme "'Mint-Y-Dark-Aqua'"

if [ ${#FALHAS[@]} -eq 0 ]; then
    echo "Instalação concluída com sucesso"
else
    echo "Instalação concluída, mas estes itens falharam: ${FALHAS[*]}"
fi

echo "Dica: saia e entre na sessão de novo para o Spotify e o Bitwarden aparecerem no menu e o uv entrar no PATH"
