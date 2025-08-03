#!/bin/bash
# -aux
# Este script tem duas funcionalidades para verificar conectividade de IPs:
# 1. mode_slow: Lê IPs de um arquivo e verifica ping de cada um
# 2. mode_fast: Realiza ping paralelo para uma faixa de IPs 192.168.1.0/24

#
#REFERENCIA:
# [1] http://andredeo.blogspot.com/2013/05/zabbix-e-passagem-de-parametros.html
# [2] https://stackoverflow.com/questions/503171/send-a-ping-to-each-ip-on-a-subnet
#
# EXEMPLOS:
# /TEMPLATE_Menu_Tam_Arq_Dir.sh quant_arq /var/log
# /TEMPLATE_Menu_Tam_Arq_Dir.sh tam_dir /var
# /TEMPLATE_Menu_Tam_Arq_Dir.sh am_arq /etc/passwd

#Versão
# DATA #Versão # FUNÇÃO
# 24-07-2024 | 0.2 | incluido em classes para futuro menu
# 2025-04-21 | 0.3 | Incluido Menu e descomentado modo rápido e modo lento
#############################################################################

# Função para modo lento - lê IPs de um arquivo e faz ping de cada um
mode_fast()
{
echo $(seq 254) | xargs -P255 -I% -d" " ping -W 1 -c 1 192.168.1.% | grep -E "[0-1].*?:"
}

# Função para modo lento - lê IPs de um arquivo e faz ping de cada um
mode_slow()
{
while read line
do
        /usr/bin/ping -c5 $line > /dev/null
        if [ $? == 0 ];
        then
        echo "$line is pinging"
        else
        echo "$line is not pinging"
        fi
done < ipreport.txt
}

# Função para exibir o menu
show_menu() {
    clear
    echo "====================================="
    echo "          PING IP CHECKER            "
    echo "====================================="
    echo "1. Modo Lento (Ler IPs do arquivo)"
    echo "2. Modo Rápido (Verificar rede 192.168.1.0/24)"
    echo "0. Sair"
    echo "====================================="
    echo -n "Digite sua escolha [0-2]: "
    read choice
}

# Loop principal do menu
while true; do
    show_menu
    case $choice in
        1)
            echo "Executando no modo lento (verificando IPs do arquivo)"
            echo "Certifique-se de que o arquivo ipreport.txt existe"
            echo "Pressione Enter para continuar..."
            read
            mode_slow
            echo "Pressione Enter para voltar ao menu..."
            read
            ;;
        2)
            echo "Executando no modo rápido (verificando toda a rede 192.168.1.0/24)"
            echo "Pressione Enter para continuar..."
            read
            mode_fast
            echo "Pressione Enter para voltar ao menu..."
            read
            ;;
        0)
            echo "Saindo do programa..."
            exit 0
            ;;
        *)
            echo "Opção inválida!"
            echo "Pressione Enter para continuar..."
            read
            ;;
    esac
done
