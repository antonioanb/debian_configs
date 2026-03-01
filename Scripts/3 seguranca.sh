#!/bin/bash

# 1. Instalação dos pacotes
echo "--- Instalando UFW e Fail2Ban ---"
apt update && apt install -y ufw fail2ban

# 2. Configuração do Firewall (UFW)
echo "--- Configurando Firewall ---"
# Redefine para o padrão (bloqueia entrada, permite saída)
ufw default deny incoming
ufw default allow outgoing

# Abre portas essenciais (ajuste conforme necessário)
ufw allow ssh
# ufw allow http
# ufw allow https

# Ativa o firewall (sem pedir confirmação interativa)
ufw --force enable

# 3. Configuração do Fail2Ban
echo "--- Configurando Fail2Ban ---"
# Cria um arquivo de configuração local para não sobrescrever o padrão
cat <<EOF > /etc/fail2ban/jail.local
[DEFAULT]
# Bane o IP por 1 hora se errar 5 vezes em 10 minutos
bantime  = 1h
findtime  = 10m
maxretry = 5

[sshd]
enabled = true
port    = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
EOF

# Reinicia os serviços para aplicar as mudanças
systemctl restart fail2ban
systemctl enable fail2ban

echo "--- Configuração concluída com sucesso! ---"
echo "Status do Firewall:"
ufw status
echo "Status do Fail2Ban:"
fail2ban-client status sshd