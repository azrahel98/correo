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
#------------------------------------------------
function mailfile ()
{
sudo rm -R /etc/dovecot/dovecot.conf
echo " " >> /etc/dovecot/dovecot.conf
echo "protocols = imap pop3" >> /etc/dovecot/dovecot.conf
echo " ">> /etc/dovecot/dovecot.conf
echo " ">> /etc/dovecot/dovecot.conf
echo "dict {">> /etc/dovecot/dovecot.conf
echo "  #quota = mysql:/etc/dovecot/dovecot-dict-sql.conf.ext">> /etc/dovecot/dovecot.conf
echo "  #expire = sqlite:/etc/dovecot/dovecot-dict-sql.conf.ext">> /etc/dovecot/dovecot.conf
echo "}">> /etc/dovecot/dovecot.conf
echo " ">> /etc/dovecot/dovecot.conf
echo " ">> /etc/dovecot/dovecot.conf
echo "!include conf.d/*.conf">> /etc/dovecot/dovecot.conf
echo "!include_try local.conf">> /etc/dovecot/dovecot.conf

sudo rm -R /etc/dovecot/conf.d/10-mail.conf

echo "     mail_location = mbox:~/mail:INBOX=/var/mail/%u" >>/etc/dovecot/conf.d/10-mail.conf
echo " ">>/etc/dovecot/conf.d/10-mail.conf
echo "namespace inbox {">>/etc/dovecot/conf.d/10-mail.conf
echo "   ">>/etc/dovecot/conf.d/10-mail.conf
echo "  inbox = yes">>/etc/dovecot/conf.d/10-mail.conf
echo "} ">>/etc/dovecot/conf.d/10-mail.conf
 
}











#-----------------------------------------------

function dnsfile(){
cd /etc
sudo rm -R named.conf

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
echo '	bindkeys-file "/etc/named.iscdlv.key";' >> named.conf
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



sudo rm -R forward.cruz
echo '$TTL 86400 ' >> forward.cruz
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
echo "@         IN      A       $s" >> forward.cruz
echo " " >> forward.cruz
echo "dns       IN      A       $s" >> forward.cruz
echo "www       IN      A       $s" >> forward.cruz
echo "ftp       IN      A       $s" >> forward.cruz

sudo rm -R reverse.cruz 
echo '$TTL 86400 ' >> reverse.cruz
echo "@         IN      SOA     dns.$dominio. root.$dominio. (" >> reverse.cruz
echo "          2011071001      ;Serial"  >> reverse.cruz
echo "          3600            ;Refresh" >> reverse.cruz
echo "          1800            ;Retry"  >> reverse.cruz
echo "          604800          ;Expire" >> reverse.cruz
echo "          86400           ;Minimun TTL" >> reverse.cruz
echo ")" >> reverse.cruz
echo "@       IN      NS       dns.$dominio.">> reverse.cruz
echo "@       IN      PTR      $dominio.">> reverse.cruz
echo "dns     IN      A        $s">> reverse.cruz
echo "www     IN      A        $s">> reverse.cruz
echo "ftp     IN      A        $s">> reverse.cruz
echo "$d     IN      PTR      dns.$dominio.">> reverse.cruz
echo "$d     IN      PTR      www.$dominio.">> reverse.cruz
echo "$d     IN      PTR      ftp.$dominio.">> reverse.cruz


service firewalld stop
setenforce 0
service named restart

nslookup $s

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
dnsfile

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
echo "Deseas usar Autenticacion de Usuario ?"
echo "1 - Si"
echo "2 - No"
read userftp
if [ $userftp == 2 ]
then
#Aqui van el codigo 
echo "Mira wey"
elif [ $userftp == 1 ]
then
clear
echo "Estos son los usuarios de tu Sistema"
echo "  "
ls /home


echo "cual de estos usuarios usuaras ? "
read usuario
echo "Estas Segur@ de Continuar ? no hay vuelta Atras D: jajaj"
echo "1 - SI ,Continuo"
echo "2 - No ,no estoy seguro wey "
read opcionftp

if [ $opcionftp == 1 ] 
then
sudo rm -R /etc/vsftpd/vsftpd.conf
sudo rm -R /etc/vsftpd.conf
echo 'anonymous_enable=NO' >> /etc/vsftpd/vsftpd.conf
echo '#' >> /etc/vsftpd/vsftpd.conf
echo '# Uncomment this to allow local users to log in.' >> /etc/vsftpd/vsftpd.conf
echo '# When SELinux is enforcing check for SE bool ftp_home_dir' >> /etc/vsftpd/vsftpd.conf
echo 'local_enable=YES' >> /etc/vsftpd/vsftpd.conf
echo '#' >> /etc/vsftpd/vsftpd.conf
echo '# Uncomment this to enable any form of FTP write command.' >> /etc/vsftpd/vsftpd.conf
echo 'write_enable=YES' >> /etc/vsftpd/vsftpd.conf
echo '#' >> /etc/vsftpd/vsftpd.conf
echo '# Default umask for local users is 077. You may wish to change this to 022,' >> /etc/vsftpd/vsftpd.conf
echo '# if your users expect that (022 is used by most other ftpds)' >> /etc/vsftpd/vsftpd.conf
echo 'local_umask=022' >> /etc/vsftpd/vsftpd.conf
echo '#' >> /etc/vsftpd/vsftpd.conf
echo '# Uncomment this to allow the anonymous FTP user to upload files. This only' >> /etc/vsftpd/vsftpd.conf
echo '# has an effect if the above global write enable is activated. Also, you will' >> /etc/vsftpd/vsftpd.conf
echo '# obviously need to create a directory writable by the FTP user.' >> /etc/vsftpd/vsftpd.conf
echo '# When SELinux is enforcing check for SE bool allow_ftpd_anon_write, echoallow_ftpd_full_access' >> /etc/vsftpd/vsftpd.conf
echo '#anon_upload_enable=YES' >> /etc/vsftpd/vsftpd.conf
echo '#' >> /etc/vsftpd/vsftpd.conf
echo '# Uncomment this if you want the anonymous FTP user to be able to create' >> /etc/vsftpd/vsftpd.conf
echo '# new directories.' >> /etc/vsftpd/vsftpd.conf
echo '#anon_mkdir_write_enable=YES' >> /etc/vsftpd/vsftpd.conf
echo '#' >> /etc/vsftpd/vsftpd.conf
echo '# Activate directory messages - messages given to remote users when they' >> /etc/vsftpd/vsftpd.conf
echo '# go into a certain directory.' >> /etc/vsftpd/vsftpd.conf
echo 'dirmessage_enable=YES' >> /etc/vsftpd/vsftpd.conf
echo '#' >> /etc/vsftpd/vsftpd.conf
echo '# Activate logging of uploads/downloads.' >> /etc/vsftpd/vsftpd.conf
echo 'xferlog_enable=YES' >> /etc/vsftpd/vsftpd.conf
echo '#' >> /etc/vsftpd/vsftpd.conf
echo '# Make sure PORT transfer connections originate from port 20 (ftp-data).' >> /etc/vsftpd/vsftpd.conf
echo 'connect_from_port_20=YES' >> /etc/vsftpd/vsftpd.conf
echo '#' >> /etc/vsftpd/vsftpd.conf
echo '# with the listen_ipv6 directive.' >> /etc/vsftpd/vsftpd.conf
echo 'listen=NO' >> /etc/vsftpd/vsftpd.conf
echo '# Mae sure, that one of the listen options is commented !!' >> /etc/vsftpd/vsftpd.conf
echo 'listen_ipv6=YES' >> /etc/vsftpd/vsftpd.conf
echo 'pam_service_name=vsftpd' >> /etc/vsftpd/vsftpd.conf
echo 'userlist_enable=YES' >> /etc/vsftpd/vsftpd.conf
echo 'tcp_wrappers=YES' >> /etc/vsftpd/vsftpd.conf
echo "anon_root= /home/$a" >> /etc/vsftpd/vsftpd.conf
echo "Agregando permisos "
chgrp ftp $usuario
echo "activando servicios"
clear
service firewalld stop
service vsftpd restart

else
echo "Error Intenta denuevo , Usa denuevo el scrip con datos correctos"
exit 1
fi



else 
echo "Error"
exit 1
fi


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

