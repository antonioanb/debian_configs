#!/usr/bin/env bash

# 💎 Limpador de metadados com barra de progresso e log amigável
# Versão aprimorada com verificação de dependências, modo recursivo e mais formatos

# Configurações
KEEP_BACKUP=false
RECURSIVE=false
SUPPORTED_FORMATS="*.jpg *.jpeg *.png *.gif *.webp *.tiff *.bmp"

# Processa argumentos
for arg in "$@"; do
    case $arg in
        -r|--recursive) RECURSIVE=true ;;
        --keep-backup) KEEP_BACKUP=true ;;
        -h|--help)
            echo "Uso: $0 [opções]"
            echo "  -r, --recursive    Processa subdiretórios"
            echo "  --keep-backup      Mantém arquivos ._original"
            echo "  -h, --help         Mostra esta ajuda"
            exit 0
            ;;
    esac
done

# Verifica dependências
check_dependencies() {
    local missing=()
    
    if ! command -v exiftool &> /dev/null; then
        missing+=("exiftool")
    fi
    
    if ! command -v mogrify &> /dev/null; then
        missing+=("imagemagick (mogrify)")
    fi
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo "❌ Dependências faltando:"
        printf '   - %s\n' "${missing[@]}"
        echo "💡 Instale com:"
        echo "   sudo apt install exiftool imagemagick  # Debian/Ubuntu"
        echo "   brew install exiftool imagemagick      # macOS"
        exit 1
    fi
}

# Inicialização
check_dependencies
log_file="clean_log_$(date +%Y-%m-%d_%H-%M-%S).txt"
errors=0

echo "📜 Salvando log em: $log_file"
echo "🧹 Iniciando limpeza de metadados..." | tee -a "$log_file"
echo >> "$log_file"

# Coleta arquivos
if [ "$RECURSIVE" = true ]; then
    echo "📂 Modo recursivo ativado" | tee -a "$log_file"
    mapfile -t files < <(find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) | sort)
else
    files=(*.jpg *.jpeg *.png *.gif *.webp)
    # Remove entradas com asterisco (quando não há arquivos)
    files=($(printf "%s\n" "${files[@]}" | grep -v '^\*\.'))
fi

total=${#files[@]}
current=0

if [ $total -eq 0 ]; then
    echo "❌ Nenhum arquivo de imagem encontrado!" | tee -a "$log_file"
    exit 1
fi

echo "📸 Encontrados $total arquivos para processar" | tee -a "$log_file"
echo

# Função para barra de progresso
progress_bar() {
    local progress=$1
    local total=$2
    local width=40
    local percent=$((progress * 100 / total))
    
    local filled=$((width * progress / total))
    local empty=$((width - filled))

    printf "\r⏳ ["
    printf "%0.s#" $(seq 1 $filled)
    printf "%0.s-" $(seq 1 $empty)
    printf "] %d%% (%d/%d)" "$percent" "$progress" "$total"
}

# Processa cada arquivo
for file in "${files[@]}"; do
    [[ -e "$file" ]] || continue

    ((current++))
    progress_bar "$current" "$total"

    # Determina formato pelo nome (case-insensitive)
    ext="${file##*.}"
    ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    
    case "$ext_lower" in
        jpg|jpeg)
            echo -e "\n📸 JPG → Limpando EXIF: $file" | tee -a "$log_file"
            if exiftool -all= "$file" >/dev/null 2>&1; then
                [ "$KEEP_BACKUP" = false ] && rm -f "${file}_original"
                echo "✔️ OK (EXIF removido)" | tee -a "$log_file"
            else
                echo "❌ ERRO ao processar $file" | tee -a "$log_file"
                ((errors++))
            fi
            ;;

        png)
            echo -e "\n🟦 PNG → Removendo chunks e perfis: $file" | tee -a "$log_file"
            if mogrify -strip "$file"; then
                echo "✔️ OK (transparência preservada)" | tee -a "$log_file"
            else
                echo "❌ ERRO ao processar $file" | tee -a "$log_file"
                ((errors++))
            fi
            ;;

        webp|gif|tiff|bmp)
            icon="🟩"
            [ "$ext_lower" = "gif" ] && icon="🟨"
            echo -e "\n${icon} ${ext_lower^^} → Limpando metadados: $file" | tee -a "$log_file"
            if exiftool -all= "$file" >/dev/null 2>&1; then
                [ "$KEEP_BACKUP" = false ] && rm -f "${file}_original"
                echo "✔️ OK (limpo)" | tee -a "$log_file"
            else
                echo "❌ ERRO ao processar $file" | tee -a "$log_file"
                ((errors++))
            fi
            ;;
            
        *)
            echo -e "\n⚠️  Formato não suportado: $file" | tee -a "$log_file"
            ((errors++))
            ;;
    esac
done

# Resumo final
echo -e "\n\n📊 RESUMO FINAL:" | tee -a "$log_file"
echo "   ✅ Processados: $current arquivos" | tee -a "$log_file"
echo "   ❌ Com erro: $errors arquivos" | tee -a "$log_file"
echo "   📁 Modo recursivo: $([ "$RECURSIVE" = true ] && echo "Sim" || echo "Não")" | tee -a "$log_file"
echo "   🕒 Finalizado em: $(date +%H:%M:%S)" | tee -a "$log_file"
echo -e "\n🎉 Concluído! Log salvo em: $log_file"
