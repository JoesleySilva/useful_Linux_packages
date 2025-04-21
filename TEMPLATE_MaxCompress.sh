#!/bin/bash

# Script para testar múltiplos algoritmos de compressão em um arquivo
# e escolher o que oferece melhor taxa de compressão

# Verificar se o nome do arquivo foi fornecido
if [ $# -lt 1 ]; then
    echo "Uso: $0 <arquivo>"
    echo "Exemplo: $0 meuarquivo.txt"
    exit 1
fi

# Verificar se o arquivo existe
if [ ! -f "$1" ]; then
    echo "Erro: O arquivo '$1' não existe."
    exit 1
fi

ARQUIVO="$1"
NOME_ARQUIVO=$(basename "$ARQUIVO")
DATA=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="compressao_log_$DATA.txt"
TEMP_DIR="/tmp/compressao_test_$DATA"
MELHOR_METODO=""
MELHOR_TAMANHO=999999999999  # Tamanho inicial muito grande para comparação

# Criar diretório temporário
mkdir -p "$TEMP_DIR"

# Função para registrar informações no log
log() {
    echo "$1" | tee -a "$LOG_FILE"
}

# Iniciar o log
log "==================================================="
log "Teste de compressão para: $ARQUIVO"
log "Data e hora: $(date)"
log "Tamanho original: $(du -h "$ARQUIVO" | cut -f1) ($(stat -c%s "$ARQUIVO") bytes)"
log "==================================================="

# Função para testar um método de compressão
testar_compressao() {
    METODO="$1"
    COMANDO_COMP="$2"
    ARQUIVO_SAIDA="$3"
    
    log "\nTestando $METODO..."
    
    # Executar compressão e medir tempo
    TEMPO_INICIO=$(date +%s.%N)
    eval "$COMANDO_COMP" > /dev/null 2>&1
    TEMPO_FIM=$(date +%s.%N)
    
    if [ -f "$ARQUIVO_SAIDA" ]; then
        TAMANHO=$(stat -c%s "$ARQUIVO_SAIDA")
        TAMANHO_ORIGINAL=$(stat -c%s "$ARQUIVO")
        TAXA=$(echo "scale=2; (1 - $TAMANHO / $TAMANHO_ORIGINAL) * 100" | bc)
        TEMPO=$(echo "$TEMPO_FIM - $TEMPO_INICIO" | bc)
        
        log "  Tamanho comprimido: $(du -h "$ARQUIVO_SAIDA" | cut -f1) ($TAMANHO bytes)"
        log "  Taxa de compressão: $TAXA%"
        log "  Tempo de compressão: $TEMPO segundos"
        
        # Verificar se este método tem a melhor compressão até agora
        if [ "$TAMANHO" -lt "$MELHOR_TAMANHO" ]; then
            MELHOR_TAMANHO=$TAMANHO
            MELHOR_METODO=$METODO
            MELHOR_ARQUIVO=$ARQUIVO_SAIDA
        fi
    else
        log "  Falha na compressão com $METODO"
    fi
}

# Testar diferentes métodos de compressão
# gzip (3 níveis diferentes)
testar_compressao "gzip (nível padrão)" "gzip -c '$ARQUIVO' > '$TEMP_DIR/$NOME_ARQUIVO.gz'" "$TEMP_DIR/$NOME_ARQUIVO.gz"
testar_compressao "gzip (nível máximo)" "gzip -9 -c '$ARQUIVO' > '$TEMP_DIR/$NOME_ARQUIVO.gz.max'" "$TEMP_DIR/$NOME_ARQUIVO.gz.max"
testar_compressao "gzip (nível rápido)" "gzip -1 -c '$ARQUIVO' > '$TEMP_DIR/$NOME_ARQUIVO.gz.fast'" "$TEMP_DIR/$NOME_ARQUIVO.gz.fast"

# bzip2
testar_compressao "bzip2" "bzip2 -c '$ARQUIVO' > '$TEMP_DIR/$NOME_ARQUIVO.bz2'" "$TEMP_DIR/$NOME_ARQUIVO.bz2"
testar_compressao "bzip2 (nível máximo)" "bzip2 -9 -c '$ARQUIVO' > '$TEMP_DIR/$NOME_ARQUIVO.bz2.max'" "$TEMP_DIR/$NOME_ARQUIVO.bz2.max"

# xz
testar_compressao "xz" "xz -c '$ARQUIVO' > '$TEMP_DIR/$NOME_ARQUIVO.xz'" "$TEMP_DIR/$NOME_ARQUIVO.xz"
testar_compressao "xz (nível máximo)" "xz -9 -c '$ARQUIVO' > '$TEMP_DIR/$NOME_ARQUIVO.xz.max'" "$TEMP_DIR/$NOME_ARQUIVO.xz.max"

# zip
testar_compressao "zip" "zip -q -j '$TEMP_DIR/$NOME_ARQUIVO.zip' '$ARQUIVO'" "$TEMP_DIR/$NOME_ARQUIVO.zip"
testar_compressao "zip (nível máximo)" "zip -9 -q -j '$TEMP_DIR/$NOME_ARQUIVO.zip.max' '$ARQUIVO'" "$TEMP_DIR/$NOME_ARQUIVO.zip.max"

# 7z
if command -v 7z &> /dev/null; then
    testar_compressao "7z" "7z a -bd '$TEMP_DIR/$NOME_ARQUIVO.7z' '$ARQUIVO' > /dev/null" "$TEMP_DIR/$NOME_ARQUIVO.7z"
    testar_compressao "7z (ultra)" "7z a -bd -mx=9 '$TEMP_DIR/$NOME_ARQUIVO.7z.ultra' '$ARQUIVO' > /dev/null" "$TEMP_DIR/$NOME_ARQUIVO.7z.ultra"
fi

# zstd
if command -v zstd &> /dev/null; then
    testar_compressao "zstd" "zstd -c '$ARQUIVO' > '$TEMP_DIR/$NOME_ARQUIVO.zst'" "$TEMP_DIR/$NOME_ARQUIVO.zst"
    testar_compressao "zstd (nível máximo)" "zstd -19 -c '$ARQUIVO' > '$TEMP_DIR/$NOME_ARQUIVO.zst.max'" "$TEMP_DIR/$NOME_ARQUIVO.zst.max"
fi

# lrzip (apenas para arquivos maiores)
TAMANHO_MB=$(du -m "$ARQUIVO" | cut -f1)
if command -v lrzip &> /dev/null && [ "$TAMANHO_MB" -gt 10 ]; then
    testar_compressao "lrzip" "lrzip -q -o '$TEMP_DIR/$NOME_ARQUIVO.lrz' '$ARQUIVO'" "$TEMP_DIR/$NOME_ARQUIVO.lrz"
fi

# Resultados finais
log "\n==================================================="
log "RESULTADOS FINAIS:"
log "==================================================="
log "Melhor método de compressão: $MELHOR_METODO"
log "Tamanho obtido: $(du -h "$MELHOR_ARQUIVO" | cut -f1) ($MELHOR_TAMANHO bytes)"
TAXA_FINAL=$(echo "scale=2; (1 - $MELHOR_TAMANHO / $(stat -c%s "$ARQUIVO")) * 100" | bc)
log "Taxa de compressão: $TAXA_FINAL%"

# Copiar o arquivo com melhor compressão para o diretório atual
ARQUIVO_FINAL="$NOME_ARQUIVO.$(echo $MELHOR_ARQUIVO | sed 's/.*\.//')"
cp "$MELHOR_ARQUIVO" "./$ARQUIVO_FINAL"
log "Arquivo comprimido salvo como: $ARQUIVO_FINAL"

# Limpar arquivos temporários
log "\nRemovendo arquivos temporários..."
rm -rf "$TEMP_DIR"

log "\nProcesso concluído. Registro salvo em: $LOG_FILE"

echo "==================================================="
echo "Melhor método: $MELHOR_METODO com taxa de $TAXA_FINAL% de compressão"
echo "Arquivo salvo como: $ARQUIVO_FINAL"
echo "Log completo disponível em: $LOG_FILE"
echo "==================================================="
