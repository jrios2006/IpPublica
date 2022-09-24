#!/bin/bash
## Programa para enviarnos por correo electronico la Ip de salida 
## de nuestra red si cambia 
## 

## Software necesario sendemail, curl y debe de estar operativo ifconfig.me
## aptitude install sendemail
#sendEmail -o tls=yes -f YourEmail@gmail.com -t SomeoneYoureEmailing@domain.com -s smtp.gmail.com:587 -xu YourEmail@gmail.com -xp YOURPASSWORD -u "Hello from sendEmail" -m "How are you? I'm testing sendEmail from the command line." 

## Variables para enviar correo electronico (usamos gmail con TLS) debemos de verificar que la cuenta de gmail puede enviar
ServidorCorreo=smtp.gmail.com:587
UsuarioCorreo=cuenta@gmail.com
PassCorreo=ContraseñaCorreo
FromCorreo=cuenta@gmail.com
DestCorreo=destinatario@gmail.com

## Variables para los ficheros que se necesitan
## Cambiar las rutas de los ficheros si no interesa la ruta /tmp
IpActual=/tmp/IpActual
IpAntigua=/tmp/IpAntigua
IpRegistro=/tmp/LogDiferentesIp


## Comprobar que Ruta_Montar existe
if [ -e $IpActual ]; then
	echo "El fichero $IpActual existe"
	## Obtenermos la IpActual y creamos los ficheros
	###Ip=$(GET http://www.vermiip.es/  | grep "Tu IP p&uacute;blica es:" | cut -d ':' -f2 | cut -d '<' -f1 | cut -d ' ' -f2)
	Ip=$(curl ifconfig.me)
	#Obtengo la hora de proceso
	Fecha=`date +%Y-%m-%d:%H:%M:%S`
	echo "$Ip;$Fecha"
	## El fichero $IpAntigua debe existir, lo creo la primera ejecución del programa
	IpOLD=$(cat $IpAntigua)
	echo "La ultima ip antigua registrada es $IpOLD"
	if [ $Ip = $IpOLD ]; then
		## La Ip no ha cambiado
		echo "La ip de salida a internet no ha cambiado. No hacemos nada"
	else
		## La Ip de salida ha cambiado
		echo $Ip > $IpActual
		echo $Ip > $IpAntigua
		echo "$Ip;$Fecha" >> $IpRegistro
		Historia=$(cat $IpRegistro)
		## Avisamos de la Ip por correo
		sendEmail -o tls=yes -f $FromCorreo -t $DestCorreo -s $ServidorCorreo -xu $UsuarioCorreo -xp $PassCorreo -u "La Ip Publica de salida de tu conexion de CASA es: $Ip" -m "La Ip publica actual de salida a Internet es: $Ip\n\nLas diferentes Ip que has tenido son:\n$Historia" 
	fi
else
	echo "El fichero no $IpActual no existe"
	## Obtenermos la IpActual y creamos los ficheros
	###Ip=$(GET http://www.vermiip.es/  | grep "Tu IP p&uacute;blica es:" | cut -d ':' -f2 | cut -d '<' -f1 | cut -d ' ' -f2)
	Ip=$(curl ifconfig.me)
	#Obtengo la hora de proceso
	Fecha=`date +%Y-%m-%d:%H:%M:%S`
	echo "$Ip;$Fecha"
	## Registrmos el log
	echo "$Ip;$Fecha" >> $IpRegistro	
	## Copiamos fichero antiguo
	echo $Ip > $IpActual
	echo $Ip > $IpAntigua
	Historia=$(cat $IpRegistro)
	## Avisamos de la Ip por correo
	sendEmail -o tls=yes -f $FromCorreo -t $DestCorreo -s $ServidorCorreo -xu $UsuarioCorreo -xp $PassCorreo -u "La Ip Publica de salida de tu conexion de CASA es: $Ip" -m "La Ip publica actual de salida a Internet es: $Ip\n\nLas diferentes Ip que has tenido son:\n$Historia"
fi
