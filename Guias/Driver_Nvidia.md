# Instalar driver Nvidia no Debian 13


colocar os repositórios 'contrib non-free' no arquivo /etc/apt/sources.list, exemplo:

```
deb http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware
```
Salvar e saia.

proximos comandos:

```
sudo apt update
sudo apt upgrade
```
depois:
```
sudo apt install linux-headers-$(uname -r)
sudo apt install nvidia-kernel-dkms
sudo apt install nvidia-driver
sudo reboot
```
verificar:
```
 nvidia-smi
lsmod | grep  nvidia
glxinfo | grep render
```

fonte: https://www.vivaolinux.com.br/dica/Instalar-driver-Nvidia-no-Debian-13