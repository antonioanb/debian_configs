#!/bin/bash

# =============================
# Script: instalarApps.sh
# Instala pacotes essenciais via APT
# Para Debian 13 ou derivados
# =============================

# === Estilo e cores ===
VERDE="\033[0;32m"
VERMELHO="\033[0;31m"
AMARELO="\033[1;33m"
AZUL="\033[0;36m"
RESET="\033[0m"
BOLD=$(tput bold)

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

# === Verifica root ou define uso do sudo ===
if [[ $EUID -ne 0 ]]; then
  SUDO="sudo"
else
  SUDO=""
fi

# === Log com timestamp ===
DATA=$(date +%Y-%m-%d_%H-%M-%S)
LOG_ERROS="apt_erros_$DATA.log"

# =============================
# Atualiza o sistema
# =============================
echo -e "${BOLD}${AZUL}📦 Iniciando instalação dos pacotes APT essenciais...${RESET}"
echo "=============================="

echo -e "${AZUL}🔄 Atualizando repositórios e sistema...${RESET}"

if command -v nala &>/dev/null; then
  $SUDO nala update && $SUDO nala upgrade -y
else
  $SUDO apt update && $SUDO apt upgrade -y
fi

# =============================
# Lista de pacotes
# =============================
apps=(
  git
  curl
  wget
  zip
  btop
  nala
  sl
  cmatrix
  flameshot
    
)

# =============================
# Instalação dos pacotes
# =============================
for app in "${apps[@]}"; do
  if dpkg-query -W -f='${Status}' "$app" 2>/dev/null | grep -q "install ok installed"; then
    echo -e "${VERDE}✔️  $app já está instalado. Pulando...${RESET}"
  else
    echo -e "${AMARELO}➡️  Instalando $app...${RESET}"
    if ! $SUDO apt install -y "$app"; then
      echo -e "${VERMELHO}❌ Erro ao instalar $app${RESET}" | tee -a "$LOG_ERROS"
    fi
  fi
done

# =============================
# Resultado final
# =============================
echo -e "\n=============================="
if [ -s "$LOG_ERROS" ]; then
  echo -e "${AMARELO}⚠️  Alguns pacotes falharam. Veja o log: $LOG_ERROS${RESET}"
else
  echo -e "${VERDE}✅ Todos os pacotes foram instalados com sucesso!${RESET}"
fi

