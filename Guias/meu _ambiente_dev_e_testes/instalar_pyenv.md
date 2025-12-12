## O pyenv é serve para gerenciar múltiplas versões do Python sem conflitos com a versão do sistema.

### esse passo a passo funciona no Linux Mint/Ubunto e derivados usando o instalador automatico.


## 1. Instalar as Dependências Necessárias

O pyenv e o processo de construção de novas versões do Python a partir do código-fonte exigem algumas bibliotecas e ferramentas de desenvolvimento.

Abra o seu terminal e execute o seguinte comando:
Bash
```
sudo apt update
sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git
```

## 2. Instalar o pyenv

usando o pyenv-installer, que automatiza o download e a configuração inicial.

Execute o seguinte comando no terminal:
Bash
```
curl https://pyenv.run | bash
```
Ao final da execução, o script do instalador fornecerá as linhas que precisaram ser adicionadas ao  arquivo de configuração de shell (geralmente ~/.bashrc no Ubuntu/Mint).

## 3. Configurar o Ambiente Shell

as linhas de inicialização do pyenv precisaram ser adicionadas ao arquivo de perfil do shell (~/.bashrc  se  usa Bash, ou ~/.zshrc se usa Zsh).

Para o Bash (o shell padrão no Ubuntu/Mint):

### 3.1. Adicionar as linhas de configuração

Executar os comandos abaixo. Eles adicionarão a configuração necessária ao final do seu arquivo ~/.bashrc:
Bash

```
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> ~/.bashrc
```
### 3.2. Recarregar o Shell

Para que as alterações entrem em vigor na sessão atual, o arquivo de configuração precisa ser recarregado:

```
source ~/.bashrc
```

Se o pyenv ainda não funcionar após recarregar, deve fechar e reabrir o terminal, ou executar:

```
exec "$SHELL"
``` 

## 4. Verificar a Instalação

confirmação se o pyenv foi instalado corretamente:
Bash
```
pyenv --version
```

a versão instalada do pyenv deve aparecer.

## 5. Usar o pyenv (Instalar uma Versão do Python)

Agora é possivel instalar qualquer versão do Python que precisar.

### 5.1. Listar Versões Disponíveis

ver quais versões estão disponíveis para instalação:

```
pyenv install --list
```
### 5.2. Instalar uma Versão Específica

Para instalar, por exemplo, o Python 3.11.7:

```
pyenv install 3.11.7
```

***Nota: A instalação do Python a partir do código-fonte pode levar alguns minutos.***

### 5.3. Definir a Versão Global

definir a versão do Python instalada como a padrão para todo o seu sistema de usuário:

```
pyenv global 3.11.7
```
### 5.4. Verificar a Versão Ativa

Verifique se a versão correta do Python está sendo usada:

```
python --version
```
Pronto! 😊  Agora com o  pyenv instalado é possivel gerenciar diferentes versões do Python facilmente, inclusive usando pyenv local <versão> dentro de diretórios de projetos específicos.