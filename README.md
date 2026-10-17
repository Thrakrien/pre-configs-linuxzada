# pre-configs-linuxzada

Repositório apenas para automatização dos programas ao fazer distrohopping (a arte de ficar pulando de distro linux igual um maluco).

Entretanto, o arquivo bash serve apenas para distros baseadas em [Debian ou Ubuntu](https://upload.wikimedia.org/wikipedia/commons/a/ad/2023_Linux_Distributions_Timeline.svg), 

Para utilizar o script, talvez seja necessário tornar o mesmo um executável depois de copiar o arquivo *saving_time_install.sh*:

```
chmod +x saving_time_install.sh

```

E depois, para executar arquivo, basta apenas executarmos o comando abaixo no terminal:

```
./saving_time_install.sh

```

Rode o script como seu usuário normal (sem `sudo` na frente): ele pede a senha quando precisa, e as fontes, o uv e o tema são instalados na sua pasta pessoal.

## O que o script instala

| O quê | Como |
| ----- | ---- |
| Git, Neovim, curl e afins | `apt` |
| Spotify | Flatpak (Flathub). O repositório `apt` do Spotify troca a chave GPG com frequência e acaba quebrando o `apt update`, então o Flatpak dá menos dor de cabeça. Se existir o repositório antigo de uma instalação anterior, o script remove |
| Bitwarden | Flatpak (pacote oficial do Bitwarden no Flathub) |
| [uv](https://docs.astral.sh/uv/) (Python) | instalador oficial da Astral, em `~/.local/bin` |
| VSCode | repositório oficial da Microsoft (só se ainda não estiver instalado) |
| Anti-Blind Theme (VSCode) | copiado para `~/.vscode/extensions` |
| Nerd Fonts | JetBrains Mono, Fira Code, Hack, Cascadia Code (CaskaydiaCove) e Geist Mono, em `~/.local/share/fonts` |
| Fontes extras | Inter (interface), Noto Color Emoji e Font Awesome (ícones para barras como Polybar e Waybar) |
| Tema de ícones `Mint-Y-Dark-Aqua` | `dconf` (apenas Linux Mint/Cinnamon) |

Se alguma etapa falhar, o script continua com as outras e mostra no final o que deu errado. Dá para rodar de novo sem medo: o que já está instalado é pulado.

### Fontes

As [Nerd Fonts](https://www.nerdfonts.com/) são as fontes mais usadas em ricing: além das letras, elas trazem milhares de ícones (git, pastas, linguagens, bateria, wifi) usados em prompts como Starship e Powerlevel10k, no Neovim e em barras de status. Para trocar as fontes, edite a lista `NERD_FONTS` no começo do script. A **Meslo** (a recomendada pelo Powerlevel10k) e a **Iosevka** ficaram de fora por serem bem pesadas, mas é só adicionar na lista.

Depois de instaladas, elas aparecem com nomes como `JetBrainsMono Nerd Font` e `JetBrainsMono Nerd Font Mono` (a versão Mono é melhor para terminais que reclamam de ícones largos).

## Tema do VSCode

Na pasta [`vscode-theme`](vscode-theme) tem o **Anti-Blind Theme**, um tema dark com cores suaves pensado para quem tem astigmatismo. Se ainda não existir um `settings.json` do VSCode, o script já cria um com o tema e a JetBrainsMono Nerd Font ativados; se existir, ele não mexe nas suas configurações. Mais detalhes no [README do tema](vscode-theme/README.md).
