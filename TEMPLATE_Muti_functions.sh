#!/bin/bash
:' Função: Telnet, ping e checagem de sudoers 
validado em 10.120.72.15/23
versão 1.0 06/06/2023 - Telnet, Ping and Checkers sudo users
'

#data=${1:-sistemas.txt}

Telnet(){
Arquivo
while read line; do
        preamble="telnet $line"
        ip=$( echo "$line" | cut -d ' ' -f1)
        port=$( echo "$line" | cut -d ' ' -f2)

        case $(/usr/bin/telnet $ip $port  </dev/null  2>&1 | tail -1 ) in
                (*closed*)  echo "$preamble ... Connected"
                ;;
                (*refused*) echo "$preamble ... Refused"
                ;;
                (*)         echo "$preamble ... Failed"
        esac
done < $data
Principal
}

Arquivo(){
	echo "digite o local do arquivo"
	read arquivo
	data=${1:-$arquivo}
}

Ping(){
Arquivo
while read line
do
        /usr/bin/ping $line -c 1 - 5  >/dev/null 
        if [ $? == 0 ];
        then
                echo "$line is pinging"
        else
                echo "$line is NOT pinging"
        fi
done < $data
Principal
}

SudoersRemote(){
        echo "Para qual servidor deseja descobrir ?"
	read host
	user=$(whoami)
	nome=$( getent passwd | grep p527488 | cut -d: -f5)
	echo "vamos conectar com usuário logado $user senhor(a) $nome? "
	echo "1. Sim "
	echo "2. Não. Digite o outro usuário"
	read matricula

	case $matricula in
		1) echo "Prosseguindo com a conexão conectando com o usuário '$user'"
		   #ssh -A -C $user@10.218.210.11
		   #ssh -C -t $user@$host 'getent group sudo'
		   ssh -C -t $user@$host 'grep -A 10 "# Allow members of group sudo to execute any command" /etc/passwd || exit'
		   #time
		   Principal ;;
		2) echo "Digite a matrícula para se conectar:" 
		   read matricula
		   echo "Conectando com o usuário '$matricula' "
		   #ssh -A -C $user@10.218.210.11
	   	   #ssh -C -t $matricula@$host 'getent group sudo'
		   ssh -C -t $user@$host 'grep -A 10 "# Allow members of group sudo to execute any command" /etc/passwd || exit'
		   # time
		   Principal ;;

	esac

#Principal



}

Sudoers(){
	getent group sudo
	echo "vindo vazio nenhum usuário listado"
	echo "confirmando "
	grep '^sudo:.*$' /etc/group |cut -d: -f4
	echo "ultimo comando "
	#grep -B 1 "%sudo      ALL=ALL:ALL) ALL" /etc/passwd
	grep -A 10 "# Allow members of group sudo to execute any command" /etc/passwd

	#echo $sudo
	echo "Digite 1 para executar em um servidor remoto?"
	echo "Digite 2 para voltar para o menu"
	read question
	case $question in
		1) SudoersRemote ;;
		2) Principal ;;	
	esac
}

Principal(){
echo "1. Deseja fazer telnet nos hosts?"
echo "2. Deseja fazer ping nos hosts?"
echo "3. Deseja fazer sudoers nos hosts?"
echo "4. Sair"

read opcao
case $opcao in
        1) Telnet ;;
        2) Ping ;;
        3) Sudoers ;;
        4) exit 0 ;;
esac
}

Principal
