#!/bin/bash

# Bash Menu Script Example




Principal(){
	echo "Você quer fazer download do vídeo ou apenas o audio do vídeo?************"
	echo "  1)Baixar o Video"
	echo "  2)Baixar audio no formato WAV"
	echo "  3)Baixar audio no format MP3"
	echo "  4)Para sair " 

	read n
	case $n in
		1) echo "Em construção"
	 		#read -p "Insira a URL:" address
			/usr/bin/youtube-dl -f 22 $address 
			;;
	 	2) echo "Será feito o download do audio da URL em WAV"
			#read -p "Insira a URL:" address
			/usr/bin/youtube-dl --extract-audio --audio-format wav --audio-quality 0 $address 
			Principal
			;;
		3) echo "Será feito o download do audio da URL em MP3"
		  	#read -p "Insira a URL:" address
			/usr/bin/youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 $address 
			;;
		#4) echo "You chose Option 4";;
		*) echo "invalid option";;
esac
}

read -p "De qual URL que baixar?:" address
/usr/bin/youtube-dl -F $address 
Principal





