#!/bin/bash

# =================================================================
# Script: instalar-flatpaks.sh
# Instala Flatpaks úteis com muita cafeína, organizados por categoria.
# Autor: antonio, com a juda do gpt "eu não sei muito sobre bash"
# =================================================================

# === Estilo e Cores ===
VERDE="\033[0;32m"
VERMELHO="\033[0;31m"
AMARELO="\033[1;33m"
AZUL="\033[0;36m"
RESET="\033[0m"
BOLD=$(tput bold)

# === Animação de boas-vindas ===
mensagem="
╭──────────────────────────────╮
         INSTALANDO..
     ☕ vá beber um café ☕│
╰──────────────────────────────╯
"

for ((i=0; i<${#mensagem}; i++)); do
  echo -ne "${mensagem:$i:1}"
  sleep 0.01
done
echo -e "\n"

# === Verifica root/sudo ===
# Verifica se o script está sendo executado como root.
# Define a variável SUDO para garantir que o 'apt' use 'sudo' se necessário.
if [[ $EUID -ne 0 ]]; then
  SUDO="sudo"
else
  SUDO=""
fi

# === Log com timestamp ===
# Cria um arquivo de log único para registrar erros de instalação.
DATA=$(date +%Y-%m-%d_%H-%M-%S)
LOG_ERROS="flatpak_erros_$DATA.log"

# =================================================================
# PRÉ-REQUISITOS
# =================================================================

# Verifica se Flatpak está instalado
if ! command -v flatpak &> /dev/null; then
    echo -e "${AMARELO}📦 Flatpak não encontrado. Instalando...${RESET}"
    $SUDO apt update
    if ! $SUDO apt install -y flatpak; then
        echo -e "${VERMELHO}❌ Erro crítico: não foi possível instalar o Flatpak.${RESET}"
        exit 1
    fi
fi

# Adiciona o Flathub se necessário
if ! flatpak remote-list | grep -q flathub; then
    echo -e "${AZUL}🔗 Adicionando repositório Flathub...${RESET}"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# =================================================================
# LISTA DE APLICATIVOS FLATPAK POR CATEGORIA
# =================================================================
flatpak_programas=(
    
    # ------------------------------------
    # 🛡️ SEGURANÇA E PRIVACIDADE
    # ------------------------------------
    org.keepassxc.KeePassXC               # Gerenciador de senhas seguro
    io.gitlab.librewolf-community         # Navegador Web focado em privacidade (LibreWolf)
    com.brave.Browser                     # navegador menos pior do que o chrome
    fr.romainvigier.MetadataCleaner       # Remove metadados de arquivos antes de compartilhar
    com.belmoussaoui.Decoder              # Leitor/Gerador de códigos de barras e QR codes
    com.protonvpn.www                     # cliente vpn da proton
    org.cryptomator.Cryptomator           # criptografia para nuvem

    # ------------------------------------
    # 🎨 CRIAÇÃO E MÍDIA
    # ------------------------------------
    org.kde.krita                         # Software de pintura e arte digital (Desenho/Edição)
    com.infinipaint.infinipaint           # Editor de imagem e pintura digital
    org.audacityteam.Audacity             # Editor de áudio multi-pista
    org.gnome.EasyTAG                     # Editor de tags para arquivos de áudio
    fr.handbrake.ghb                      # Transcodificador de vídeo (Conversão de formatos)
    org.videolan.VLC                      # Player de mídia universal (Vídeos e Áudios)
    com.github.rafostar.Clapper           # player de video moderno e minimalista
    com.github.neithern.g4music           # Player de música moderno

    # ------------------------------------
    # ⚙️ FERRAMENTAS DO SISTEMA
    # ------------------------------------
    com.github.tchx84.Flatseal            # Gerenciador gráfico de permissões Flatpak
    io.missioncenter.MissionCenter        # Monitor de recursos do sistema moderno (Alternativa ao Gerenciador de Tarefas)
    com.leinardi.gwe                      # Ferramenta para gerenciar GPUs (GreenWithEnvy)
    com.dec05eba.gpu_screen_recorder      # Gravador de tela otimizado para GPU
    net.davidotek.pupgui2                 # Ferramenta gráfica para gerenciar pacotes/PPAs (Package Update Picker)

    # ------------------------------------
    # 🎮 JOGOS E EMULAÇÃO
    # ------------------------------------
    net.lutris.Lutris                     # Plataforma de jogos unificada (Gerenciador de jogos)
    com.vysp3r.ProtonPlus                 # Ferramenta para gerenciar versões do Proton (Steam Deck/Jogos)
    io.mgba.mGBA                          # emulador de gba
    dev.bsnes.bsnes                       # emulador de super nintendo
    it.mijorus.gearlever                  # Gerenciador de AppImages (Permite integração fácil)
    com.ranfdev.DistroShelf               # Gerenciador de distros (para quem testa muitas)

    # ------------------------------------
    # ✉️ COMUNICAÇÃO E PRODUTIVIDADE
    # ------------------------------------
    com.rtosta.zapzap                     # Cliente não oficial do WhatsApp Web (ou outro similar)
    com.github.marktext.marktext          # Editor Markdown elegante e funcional
    com.github.ADBeveridge.Raider         # programa de exclusão de arquivo de forma permanente
    io.github.kolunmi.Bazaar              # loja alternativa
    dev.geopjr.Tuba

    # ------------------------------------
    # 🧘 AMBIENTE E DIVERSOS
    # ------------------------------------
    com.rafaelmardojai.Blanket            # Sons ambiente para foco e relaxamento
    com.ktechpit.wonderwall               # Gerenciador/Trocador de wallpapers
    com.jeffser.Pigment                   # Ferramenta para gerenciamento e criação de paletas de cores
    io.freetubeapp.FreeTube               # Cliente YouTube que respeita a privacidade
    com.github.unrud.VideoDownloader      # Baixador de vídeos
    org.upscayl.Upscayl                   # upscale de imagens
    org.qbittorrent.qBittorrent
    flatpak run com.vscodium.codium
)

# =================================================================
# INSTALAÇÃO DOS FLATPAKS
# =================================================================
echo -e "${BOLD}${AZUL}🚀 Instalador de Flatpaks CafeOS${RESET}"
echo "=================================================="

for programa in "${flatpak_programas[@]}"; do
    # Verifica se o programa já está instalado
    if flatpak info "$programa" &>/dev/null; then
        echo -e "${VERDE}✔️  $programa já está instalado. Pulando...${RESET}"
    else
        echo -e "${AMARELO}➡️  Instalando $programa...${RESET}"
        # --noninteractive: Não pede confirmação ao usuário
        if ! flatpak install -y --noninteractive flathub "$programa"; then
            echo -e "${VERMELHO}❌ Erro ao instalar $programa${RESET}" | tee -a "$LOG_ERROS"
        fi
    fi
done

# =================================================================
# RESULTADO FINAL
# =================================================================
echo -e "\n=================================================="
if [ -s "$LOG_ERROS" ]; then
    echo -e "${AMARELO}⚠️  Alguns programas falharam. Veja o log: $LOG_ERROS${RESET}"
else
    echo -e "${VERDE}✅ Todos os Flatpaks foram instalados com sucesso!${RESET}"
fi
