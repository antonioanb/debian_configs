

# 📘 Guia de Referência Git & GitHub

## 🛠️ Configuração Inicial

comandos iniciais:

| **Comando**                                      | **Descrição**                                   |
| ------------------------------------------------ | ----------------------------------------------- |
| `git config --global user.name "Seu Nome"`       | Define o nome de exibição.                      |
| `git config --global user.email "seu@email.com"` | Vincula os commits à sua conta (GitHub/GitLab). |
| `git config --list`                              | Lista todas as configurações ativas.            |

---

## 🔑 Conexão via SSH (GitHub)

Para clonar e enviar alterações sem precisar digitar senha o tempo todo.

1. **Gerar chave:** No terminal, execute:
   
   Bash
   
   ```
   ssh-keygen -t ed25519 -C "seu-email@exemplo.com"
   ```

2. **Copiar chave:** Visualize e copie o conteúdo gerado:
   
   Bash
   
   ```
   cat ~/.ssh/id_ed25519.pub
   ```

3. **Adicionar ao GitHub:** * Vá em **Settings** -> **SSH and GPG keys** -> **New SSH Key**.
   
   - Cole o código e salve com um nome (ex: "Meu Linux").

---

## 🔄 Fluxo de Trabalho e Ciclo de Vida

O Git trabalha com estados específicos para os arquivos:

- **Untracked:** Arquivo novo, ainda não visto pelo Git.

- **Modified:** Arquivo rastreado que sofreu alterações.

- **Staged:** Alterações preparadas para o commit (`git add`).

- **Committed:** Alterações salvas permanentemente no histórico.

### Áreas do Git:

`Working Directory` (Pasta local) → `Staging Area` (Preparação) → `Repository (HEAD)` (Histórico)

---

## 💻 Comandos Essenciais

### Manipulação e Status

- `git init`: Inicializa um novo repositório na pasta atual.

- `git status`: Exibe o estado atual (quais arquivos estão modificados ou no staging).

- `git add <arquivo>`: Move arquivos para a staging area.

- `git commit -m "mensagem"`: Grava as alterações com uma descrição.

- `git mv <origem> <destino>`: Renomeia/move arquivos já avisando o Git.

### Visualização e Histórico

- `git log`: Histórico completo de commits.

- `git log --oneline`: Resumo de uma linha por commit.

- `git log --graph`: Exibe o histórico com desenho das ramificações.

- `git show`: Detalhes do último commit realizado.

### Diferenças (Diff)

- `git diff`: Diferença entre o que você alterou e o que está no Staging.

- `git diff --staged`: O que está no Staging pronto para ser commitado.

---

## 🌿 Gerenciamento de Branches (Ramos)

Branches permitem isolar o desenvolvimento de novas funcionalidades.

- `git branch <nome>`: Cria uma nova ramificação.

- `git checkout <nome>`: Alterna para a branch especificada.

- `git merge <nome>`: Une as alterações da branch especificada à branch atual.

- `git branch -d <nome>`: Deleta a branch (use `-D` para forçar a exclusão).

---

## 💡 Dicas Rápidas

> **Diferença entre `git add -u` e `git add .`**
> 
> - `git add -u`: Adiciona apenas atualizações e deleções de arquivos que **já eram** rastreados.
> 
> - `git add .`: Adiciona tudo, inclusive novos arquivos (untracked).

---


