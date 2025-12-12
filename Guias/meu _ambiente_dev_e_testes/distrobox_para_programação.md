# Guia para o "Eu do Futuro" ou quem estiver lendo isso 🤷‍♂️: Ambiente Dev com Distrobox

## Objetivo

Criar um ambiente de desenvolvimento em um container sem poluir o sistema host.

---

## 1. Instalar Distrobox

```bash
sudo apt update
sudo apt install podman distrobox -y
```

## 2. Criar primeira caixinha de programação ubuntu

```bash
distrobox-create --name dev-ubuntu --image ubuntu:24.04
distrobox-enter dev-ubuntu
```

## 3. Instalar pacotes básicos

```bash
sudo apt update
sudo apt install -y git curl build-essential python3 python3-pip nodejs npm
```

## 4. Instalar VS Code

```bash
# dependências
sudo apt install -y wget gpg apt-transport-https software-properties-common

# chave e repo
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | \
  sudo gpg --dearmor -o /usr/share/keyrings/packages.microsoft.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] \
https://packages.microsoft.com/repos/code stable main" | \
  sudo tee /etc/apt/sources.list.d/vscode.list

# instalar vscode
sudo apt update
sudo apt install -y code
```

## 5. Exportar VS Code para o host

```bash
mkdir -p ~/.local/bin
distrobox-export --bin /usr/bin/code
distrobox-export --app code
```

Agora o vscode pode ser aberto pelo menu ou terminal:

```bash
code .
```

## 6. Gerenciar containers

- Listar: `distrobox-list`
  
- Entrar: `distrobox-enter dev-ubuntu`
  
- Remover: `distrobox-rm dev-ubuntu`
  

## 7. Dicas e atalhos

- Criar alias no host:
  
- ```bash
  echo 'alias dev="distrobox-enter dev-ubuntu"' >> ~/.bashrc
  source ~/.bashrc
  ```
  

## 8. Problemas que eu tive, e as soluções.

- `git: command not found` → instalar git dentro do container.
  
- `cannot create destination file ~/.local/bin/code` → criar a pasta no host: `mkdir -p ~/.local/bin`.
  

## Notas

- Sempre use containers separados pra linguagens diferentes (`dev-python`, `dev-node`, etc.)
  
- Antes de instalar qualquer pacote dentro do container, rode `sudo apt update` 🧹
  
- Se o VS Code não abrir pelo host, verifica `~/.local/bin` e o `PATH` ⚠️