# IpPublica
Conocer la Ip publica de salida para una raspberry

## Objetivo
Quiero saber cual es la dirección Ip pública de salida de una red para poder conectarme a ella a través de esa Ip y no a través de ningún servicio de nombres.

## Qué necesito

* Una máquina con GNU/Linux, en este caso una raspberry (consume poca electricidad)
* Una cuenta de correo de un servidor de correo, (puede ser gamil u otro)
* un cliente de correo que permita enviar correo
* un cliente http para poder consultar

## Para que lo hago 

Quiero conectarme a través de una VPN sabiendo solo la Ip pública y esto lo puede cambiar el operador sin aviso previo

## Qué software he usado
Para poder enviar un correo electronico necesito el cliente de correo smtp [**sendemail**](http://caspian.dotconf.net/menu/Software/SendEmail/)

Para instalarlo basta con ejecutar con permisos de root

<code>
apt-get install sendemail
</code>

Si el proveedor de correo exige TLS además de este software hay que instalar soporte para esto, esto se hace con

<code>
apt-get install libio-socket-ssl-perl
</code>

<code>
apt-get install libnet-ssleay.perl
</code>

Estos dos paquetes se pueden o no instalar a la vez que sendemail

Además necesitamos en el programa necesaitamo ejecutar el siguiente comando
<code>
GET http://www.vermiip.es/  | grep "Tu IP p&uacute;blica es:" | cut -d ':' -f2 | cut -d '<' -f1 | cut -d ' ' -f2
</code>

Con lo cual la máquina que ejecute el script debe poder ejecutar el comando GET, grep y cut

## Pasos de instalación
Descargar el fichero conocer-ip-publica.sh.

Modificar con los parámetros de la cuenta de correo necesarios

poner una línea en el cron para que se ejecute por ejemplo cada hora.

## Que hace el script
El programa intenta conectarse a Intenet al sitio [http://www.vermiip.es/](http://www.vermiip.es/) y obtiene mi dirección pública de Internet.

La almaceno en ficheros de texto en /tmp y si observo que hay un cambio me envió una alerta por mail diciendo que ip es la actual.

