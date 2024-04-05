#!/bin/bash
# -aux
#
#REFERENCIA:
# http://andredeo.blogspot.com/2013/05/zabbix-e-passagem-de-parametros.html
#
# EXEMPLOS:
# /TEMPLATE_Menu_Tam_Arq_Dir.sh quant_arq /var/log
# /TEMPLATE_Menu_Tam_Arq_Dir.sh tam_dir /var
# /TEMPLATE_Menu_Tam_Arq_Dir.sh am_arq /etc/passwd
#############################################################################

#este arquivo consta IP e PORTA. Exemplo: 
# 192.168.1.1 22
# 192.168.1.10 22

#ARQUIVO=${1:-/home/p527488/Downloads/Shell\ Script/bases_oracle.txt}
ARQUIVO=${1:-bases_oracle.txt}
#data=$(1:$ARQUIVO) 
HOST_IP=$(hostname -i)
HOSTNAME=$(hostname -s)
#


com_porta(){
        while read line; do
                preamble="$line"
                IP=$( echo "$LINE | cut -d ' ' -f1")
                PORTA=$( echo "$LINE | cut -d ' ' -f1" )

                Teste_telnet
                #case $(/usr/bin/telnet $IP $PORTA </dev/null 2>&1 | grep -q Escape
                case $(/usr/bin/telnet $IP $PORTA </dev/null 2>&1 | tial -1 ) in
                        (*closed*) echo "Telnet do servidor x ($HOSTNAME - $HOST_IP) para $preamble ... Conectado"
                        ;;
                        (*refused*) echo "Telnet do servidor x ($HOSTNAME - $HOST_IP) para $preamble ... Conexão recusada"
                        ;;
                        (*) echo "Telnet do servidor x ($HOSTNAME - $HOST_IP) para $preamble ... Falha de conexão"
                        
                esac
        done < $ARQUIVO

        Principal
}

porta_1521(){
        PORTA=1521
        while read line; do
                preamble="$LINE"
                IP=( echo "$LINE | cut -d ' ' -f1")
                
                case $(/usr/bin/telnet $IP $PORTA </dev/null 2>&1 | tail -1 ) in
                        (*closed*) echo "Telnet do servidor x ($HOSTNAME - $HOST_IP) para $preamble ... Conectado"
                        ;;
                        (*refused*) echo "Telnet do servidor x ($HOSTNAME - $HOST_IP) para $preamble ... Conexão recusada"
                        ;;
                        (*) echo "Telnet do servidor x ($HOSTNAME - $HOST_IP) para $preamble ... Falha de conexão"
                        
                esac

        done < $ARQUIVO

        Principal
}


informe_porta(){
        echo "informe a porta:"
        read $PORTA
        while read line; do
                preamble="$LINE"
                IP=( echo "$LINE | cut -d ' ' -f1")
                
                case $(/usr/bin/telnet $IP $PORTA </dev/null 2>&1 | tail -1 ) in
                        (*closed*) echo "Telnet do servidor x ($HOSTNAME - $HOST_IP) para $preamble ... Conectado"
                        ;;
                        (*refused*) echo "Telnet do servidor x ($HOSTNAME - $HOST_IP) para $preamble ... Conexão recusada"
                        ;;
                        (*) echo "Telnet do servidor x ($HOSTNAME - $HOST_IP) para $preamble ... Falha de conexão"
                        
                esac

        done < $ARQUIVO

        Principal
}

Principal(){
        echo "##########Executar Telnet: #####"
        echo "Digite 1: com as portas definidas no arquivo dos IP's."
        echo "Digite 2: na porta 1521"
        echo "Digite 3: para informar uma porta para consulta"
        echo "Digite 4: para sair!"

        read OPCAO

        case $OPCAO in
                1) com_porta ;;
                2) porta_1521 ;;
                3) informe_porta ;;
                4) exit 0 ;;
        esac
}

Principal
