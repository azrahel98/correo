#!/bin/bash

echo "Bienvenid@s Configuracion de Servidor Dns en Centos 7"

echo -e "\e[43mCual es tu Ip \e[49m"
read A
echo "Cual es tu Mascara de red solo Poner SUFIJO: Ejemplo -- 255.255.255.0 (sufijo=24), 255.255.252.0(sufijo = 22) "
read B
echo "Cual es tu Ip de Red : ejemplo = 192.168.1.0 ,10.24.0.0, 172.16.0.0 "
read C
echo "Como sera tu Dominio : ejemplo azrae.com" 
read D
echo "Poner el Reverse Ejemplo = si tu ip es 192.168.1.3 poner = 1.168.192"
read reverse


clear
echo "--------------------ENTONCES QUEDARA ASI---------------------"
echo "    Ip(Servidor) = $A"
echo "    Mascara de Red = $B "
echo "    Ip(Red) = $C "
echo "    Dominio = $D "
echo "    ARPA = $reverse"
cd etc
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
echo "	listen-on port 53 { 127.0.0.1;$A ; };" >> named.conf
echo '	listen-on-v6 port 53 { ::1; };' >> named.conf
echo '	directory 	"/var/named";' >> named.conf
echo '	dump-file 	"/var/named/data/cache_dump.db";' >> named.conf
echo '	statistics-file "/var/named/data/named_stats.txt";' >> named.conf
echo '	memstatistics-file "/var/named/data/named_mem_stats.txt";' >> named.conf
echo "	allow-query     { localhost; $C/$B; };" >> named.conf
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
echo 'zone "'"$D"'" IN { ' >> named.conf
echo '        type master; ' >> named.conf
echo '        file "forward.cruz"; ' >> named.conf
echo '        allow-update {none; }; ' >> named.conf
echo '}; ' >> named.conf
echo ' ' >> named.conf
echo 'zone "'"$reverse"'.in-addr.arpa" IN { ' >> named.conf
echo '        type master; ' >> named.conf
echo '        file "reverse.cruz"; ' >> named.conf
echo '        allow-update {none; }; ' >> named.conf
echo '}; ' >> named.conf
echo ' ' >> named.conf
echo ' ' >> named.conf
echo ' ' >> named.conf
echo 'include "/etc/named.rfc1912.zones"; ' >> named.conf
echo 'include "/etc/named.root.key"; ' >> named.conf

cd ..
cd var/named
touch forward.cruz
touch reverse.cruz

rm -R forward.cruz

echo "$TTL 86400 " >> forward.cruz
echo "@         IN      SOA     dns.$D. root.$D. (" >> forward.cruz
echo "          2011071001      ;Serial"  >> forward.cruz
echo "          3600            ;Refresh" >> forward.cruz
echo "          1800            ;Retry"  >> forward.cruz
echo "          604800          ;Expire" >> forward.cruz
echo "          86400           ;Minimun TTL" >> forward.cruz
echo ")" >> forward.cruz
echo "@         IN      NS      dns.$D." >> forward.cruz
echo "@         IN      A       $A"  >> forward.cruz
echo "@         IN      A       $A" >> forward.cruz
echo "@         IN      A       $A" >> forward.cruz
echo "@         IN      A       $A" >> forward.cruz
echo " " >> forward.cruz
echo "dns       IN      A       $A" >> forward.cruz
echo "www       IN      A       $A" >> forward.cruz


rm -R reverse.cruz

echo "$TTL 86400 " >> reverse.cruz
echo "@         IN      SOA     dns.$D. root.$D. (" >> reverse.cruz
echo "          2011071001      ;Serial"  >> reverse.cruz
echo "          3600            ;Refresh" >> reverse.cruz
echo "          1800            ;Retry"  >> reverse.cruz
echo "          604800          ;Expire" >> reverse.cruz
echo "          86400           ;Minimun TTL" >> reverse.cruz
echo ")" >> forward.cruz
echo "@       IN      NS       dns.$D.">> forward.cruz
echo "@       IN      PTR      $D.">> forward.cruz
echo "dns     IN      A        $A">> forward.cruz
echo "client  IN      A        $A">> forward.cruz
echo "254     IN      PTR      dns.$D.">> forward.cruz
echo "145     IN      PTR      ftp.$D.">> forward.cruz

chgrp named -R /var/named
chown -v root:named /etc/named.cont
service firewalld stop
setenforce 0
service httpd start
service named start

nslookup $A


