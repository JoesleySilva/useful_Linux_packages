#!/bin/bash
#set -aux

# Função para escanear IPs em uma rede local
scan_rede() {
    local rede="$1"  # Primeiro argumento será o prefixo da rede (ex: 192.168.1)

    if [ -z "$rede" ]; then
        # Se nenhum argumento for fornecido, usa 192.168.1 como padrão
        rede="192.168.1"
    fi

    echo "Escaneando rede: $rede.0/24"

    # Escaneia a rede usando xargs para paralelismo
    echo $(seq 254) | xargs -P255 -I% -d" " ping -W 1 -c 1 $rede.% | grep -E "[0-1].*?:"

    # Alternativa comentada usando um loop while
    # CONTADOR=1
    # seq 254 | while read OUTPUT
    # do
    #     ping $rede.$CONTADOR -c 1 >/dev/null
    #     let CONTADOR++
    # done
}

# Se este script for executado diretamente (não importado como biblioteca)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Se um argumento for fornecido, usa-o como prefixo de rede
    if [ -n "$1" ]; then
            echo "O IP local é "hostname -I
	    scan_rede "$1"
    else
        # Caso contrário, executa com o prefixo padrão
        scan_rede "192.168.1"
    fi
fi
