#!/usr/bin/env bash

# 📸 RENOMEADOR DE IMAGENS - Versão individual

log_file="renomeador_$(date +%Y%m%d_%H%M%S).log"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configurações padrão
prefix=""
use_zeros=false
recursive=false
dry_run=false
start_from=1

# Processa argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--prefix)
            prefix="$2"
            shift 2
            ;;
        -z|--zeros)
            use_zeros=true
            shift
            ;;
        -r|--recursive)
            recursive=true
            shift
            ;;
        -d|--dry-run)
            dry_run=true
            shift
            ;;
        -s|--start)
            start_from="$2"
            shift 2
            ;;
        -h|--help)
            echo "Uso: $0 [opções]"
            echo "  -p, --prefix TEXTO  Prefixo dos nomes (obrigatório)"
            echo "  -z, --zeros         Usar zeros (001, 002)"
            echo "  -r, --recursive     Incluir subpastas"
            echo "  -d, --dry-run       Simular sem renomear"
            echo "  -s, --start NÚMERO  Começar do número N (padrão: 1)"
            echo "  -h, --help          Mostra ajuda"
            echo
            echo "Exemplo: $0 -p viagem -z -r -s 10"
            exit 0
            ;;
        *)
            echo -e "${RED}Opção inválida: $1${NC}"
            exit 1
            ;;
    esac
done

# Verifica prefixo
if [ -z "$prefix" ]; then
    echo -e "${RED}❌ Prefixo é obrigatório!${NC}"
    echo "Use: $0 -p meu_prefixo"
    exit 1
fi

echo -e "${BLUE}📸 RENOMEADOR DE IMAGENS${NC}"
echo "=========================="
echo "Prefixo: $prefix"
echo "Zeros: $([ "$use_zeros" = true ] && echo "Sim" || echo "Não")"
echo "Recursivo: $([ "$recursive" = true ] && echo "Sim" || echo "Não")"
echo "Modo: $([ "$dry_run" = true ] && echo "SIMULAÇÃO" || echo "REAL")"
echo "Iniciar em: $start_from"
echo

# Coleta arquivos
formats=("jpg" "jpeg" "png" "gif" "webp" "bmp" "tiff")
files=()

if [ "$recursive" = true ]; then
    for ext in "${formats[@]}"; do
        while IFS= read -r -d '' file; do
            files+=("$file")
        done < <(find . -type f -iname "*.$ext" -print0 2>/dev/null | sort -z)
    done
else
    for ext in "${formats[@]}"; do
        for file in *."$ext" *."${ext^^}"; do
            [ -f "$file" ] && files+=("$file")
        done
    done
fi

total=${#files[@]}
echo -e "📸 Encontrados: ${GREEN}$total arquivos${NC}"
[ $total -eq 0 ] && { echo "❌ Nenhuma imagem"; exit 1; }

# Confirmação
echo
echo -n "🚀 Continuar? (s/N): "
read confirm
[[ ! "$confirm" =~ ^[Ss]$ ]] && { echo "👋 Cancelado"; exit 0; }

echo
echo -e "${YELLOW}✨ Renomeando...${NC}"

count=$start_from
processed=0
errors=0

for file in "${files[@]}"; do
    # Remove ./ do início se existir
    file="${file#./}"
    
    # Pega extensão em minúsculo
    ext="${file##*.}"
    ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    
    # Gera novo nome
    if [ "$use_zeros" = true ]; then
        printf -v padded "%03d" $count
        new_name="${prefix}_${padded}.${ext}"
    else
        new_name="${prefix}_${count}.${ext}"
    fi
    
    # Verifica se destino já existe
    if [ -e "$new_name" ] && [ "$dry_run" = false ]; then
        echo -e "${YELLOW}⚠️  $new_name já existe - pulando${NC}"
        echo "$(date +%H:%M:%S) ⚠️  $file → pulado (já existe)" >> "$log_file"
        ((count++))
        ((processed++))
        continue
    fi
    
    # Executa ou simula
    if [ "$dry_run" = true ]; then
        echo -e "${BLUE}🔍 [SIMULAÇÃO] $file → $new_name${NC}"
        echo "$(date +%H:%M:%S) 🔍 $file → $new_name (simulação)" >> "$log_file"
    else
        mv "$file" "$new_name"
        echo -e "${GREEN}✔️  $file → $new_name${NC}"
        echo "$(date +%H:%M:%S) ✓ $file → $new_name" >> "$log_file"
    fi
    
    ((count++))
    ((processed++))
    
    # Barra de progresso simples
    printf "\r📊 Progresso: %d/%d" $processed $total
done

echo -e "\n\n${GREEN}✅ Concluído!${NC}"
echo "   Processados: $processed"
echo "   Log: $log_file"

if [ "$dry_run" = false ] && [ $processed -gt 0 ]; then
    echo
    echo -e "${BLUE}📋 Primeiros arquivos:${NC}"
    ls -1 ${prefix}_* 2>/dev/null | head -5 | while read f; do
        echo "   📸 $f"
    done
fi
