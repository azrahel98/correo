#!/bin/bash
myip=
while IFS=$': \t' read -a line ;do
    [ -z "${line%inet}" ] && ip=${line[${#line[1]}>4?1:2]} &&
        [ "${ip#127.0.0.1}" ] && myip=$ip
  done< <(LANG=C /sbin/ifconfig)

function menu ()
{
clear
echo "              Bienvenido , Configuracion de Servidores Centos 7 Servicios Basicos"
echo "  "

echo " Escoja una opcion "
echo "1. Servidor DNS"
echo "2. Servidor FTP"
echo "3. Servidor Samba"
echo "4. Salir"
read opcion
}





function dnsfile(){
cd /etc
rm -R named.conf

echo "//" >> named.conf
echo "// named.conf" >> named.conf
echo "//" >> named.conf
echo "// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS" >> named.conf
echo "// server as a caching only nameserver (as a localhost DNS resolver only)." >> named.conf
echo "//" >> named.conf
echo "// See /usr/share/doc/bind*/sample/ for example named configuration files." >> named.conf
echo "//" >> named.conf
echo "options {" >> named.conf
echo "	listen-on port 53 { 127.0.0.1;$s ; };" >> named.conf
echo '	listen-on-v6 port 53 { ::1; };' >> named.conf
echo '	directory 	"/var/named";' >> named.conf
echo '	dump-file 	"/var/named/data/cache_dump.db";' >> named.conf
echo '	statistics-file "/var/named/data/named_stats.txt";' >> named.conf
echo '	memstatistics-file "/var/named/data/named_mem_stats.txt";' >> named.conf
echo "	allow-query     { localhost; $ipredas/$mascara; };" >> named.conf
echo " ">> named.conf
echo "	/*" >> named.conf
echo "	 - If you are building an AUTHORITATIVE DNS server, do NOT enable recursion." >> named.conf
echo "	 - If you are building a RECURSIVE (caching) DNS server, you need to enable " >> named.conf
echo "	   recursion. " >> named.conf
echo "	 - If your recursive DNS server has a public IP address, you MUST enable access " >> named.conf
echo "	   control to limit queries to your legitimate users. Failing to do so will" >> named.conf
echo "	   cause your server to become part of large scale DNS amplification " >> named.conf
echo "	   attacks. Implementing BCP38 within your network would greatly" >> named.conf
echo "	   reduce such attack surface " >> named.conf
echo "	*/" >> named.conf
echo "	recursion yes;" >> named.conf
echo " " >> named.conf
echo "	dnssec-enable yes;" >> named.conf
echo "	dnssec-validation yes;" >> named.conf
echo " " >> named.conf
echo "	/* Path to ISC DLV key */ " >> named.conf
echo "	bindkeys-file "/etc/named.iscdlv.key";" >> named.conf
echo " " >> named.conf
echo '	managed-keys-directory "/var/named/dynamic";' >> named.conf
echo " " >> named.conf
echo '	pid-file "/run/named/named.pid";' >> named.conf
echo '	session-keyfile "/run/named/session.key";' >> named.conf
echo "};" >> named.conf
echo "  " >> named.conf
echo "logging { " >> named.conf
echo "        channel default_debug {" >> named.conf
echo '                file "data/named.run";' >> named.conf
echo "                severity dynamic;" >> named.conf
echo "        };" >> named.conf
echo "};" >> named.conf
echo " " >> named.conf
echo ' zone "." IN { ' >> named.conf
echo "	type hint; " >> named.conf
echo '	file "named.ca"; ' >> named.conf
echo "}; " >> named.conf
echo " " >> named.conf
echo 'zone "'"$dominio"'" IN { ' >> named.conf
echo '        type master; ' >> named.conf
echo '        file "forward.cruz"; ' >> named.conf
echo '        allow-update {none; }; ' >> named.conf
echo '}; ' >> named.conf
echo ' ' >> named.conf
echo 'zone "'"$c.$b.$a"'.in-addr.arpa" IN { ' >> named.conf
echo '        type master; ' >> named.conf
echo '        file "reverse.cruz"; ' >> named.conf
echo '        allow-update {none; }; ' >> named.conf
echo '}; ' >> named.conf
echo ' ' >> named.conf
echo ' ' >> named.conf
echo ' ' >> named.conf
echo 'include "/etc/named.rfc1912.zones"; ' >> named.conf
echo 'include "/etc/named.root.key"; ' >> named.conf

cd .
cd /var/named
touch forward.cruz
touch reverse.cruz



echo "$TTL 86400 " >> forward.cruz
echo "@         IN      SOA     dns.$dominio. root.$dominio. (" >> forward.cruz
echo "          2011071001      ;Serial"  >> forward.cruz
echo "          3600            ;Refresh" >> forward.cruz
echo "          1800            ;Retry"  >> forward.cruz
echo "          604800          ;Expire" >> forward.cruz
echo "          86400           ;Minimun TTL" >> forward.cruz
echo ")" >> forward.cruz
echo "@         IN      NS      dns.$dominio." >> forward.cruz
echo "@         IN      A       $s"  >> forward.cruz
echo "@         IN      A       $s" >> forward.cruz
echo "@         IN      A       $s" >> forward.cruz
echo "@         IN      A       $s" >> forward.cruz
echo " " >> forward.cruz
echo "dns       IN      A       $s" >> forward.cruz
echo "www       IN      A       $s" >> forward.cruz


echo "$TTL 86400 " >> reverse.cruz
echo "@         IN      SOA     dns.$dominio. root.$dominio. (" >> reverse.cruz
echo "          2011071001      ;Serial"  >> reverse.cruz
echo "          3600            ;Refresh" >> reverse.cruz
echo "          1800            ;Retry"  >> reverse.cruz
echo "          604800          ;Expire" >> reverse.cruz
echo "          86400           ;Minimun TTL" >> reverse.cruz
echo ")" >> forward.cruz
echo "@       IN      NS       dns.$dominio.">> forward.cruz
echo "@       IN      PTR      $dominio.">> forward.cruz
echo "dns     IN      A        $dominio">> forward.cruz
echo "client  IN      A        $dominio">> forward.cruz
echo "$d     IN      PTR      dns.$dominio.">> forward.cruz
echo "$d     IN      PTR      ftp.$dominio.">> forward.cruz

chgrp named -R /var/named
chown -v root:named /etc/named.cont
service firewalld stop
setenforce 0
service httpd start
service named start

nslookup $A

}




function dns()
{
echo "Dominio : " 
 read dominio
clear
echo "Colocar ip"
read a 
read b
read c
read d
s=$(echo -n "$a.$b.$c.$d")
echo "$s"
echo ""
clear
echo "Mascara de red (22,24)"
read mascara
#echo $dominio
echo "IP de Red"
read ipredas
echo ""

if [ $s == $myip  ]
then
clear
echo "  "
echo -n "      Dominio " ; echo -n "     $dominio"
echo ""
echo -n "      IP  :" ; echo -n "       $s/$mascara"
echo "" 
echo -n "      Ip de red ;" ; echo -n "   $ipredas"
echo ""
echo "   "
echo "  "
echo " DESEAR CONTINAR ? (SI/NO)"
read continuar
if [$continuar == "NO"]
then
exit 1
elif [$continuar == "SI"]
then
dnsfile
else
exit 1
fi
else
clear
echo "Error Verifique los pasos (Ip)"
exit 1
fi
}










#------------------------------------------------------------
menu

if [ $opcion == 1  ]
then
  clear
    echo "             Configuracion de DNS "
#echo "Mascara"
#ip -o -f inet addr show | awk '/scope global/ {print $2, $4}'
dns
elif [ $opcion == 2 ]
then
clear
    echo "Configuracion de FTP"
elif [ $opcion == 3 ]
then
clear
    echo "Configuracion de Samba"
elif [ $opcion == 4 ]
then
clear
    exit 1
else
    echo "Error "
exit 1
fi
