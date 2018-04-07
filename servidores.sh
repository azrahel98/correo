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
echo "4. Servidor Correo"
echo "  "
read opcion
}
#------------------------------------------------
#archivos para correo


function dovecot () {
sudo rm -R /etc/dovecot/dovecot.conf 

echo "protocols = imap pop3 " >>/etc/dovecot/dovecot.conf 
echo " " >>/etc/dovecot/dovecot.conf 
echo "dict {" >>/etc/dovecot/dovecot.conf 
echo " " >>/etc/dovecot/dovecot.conf 
echo "} " >>/etc/dovecot/dovecot.conf 
echo " " >>/etc/dovecot/dovecot.conf 
echo "!include conf.d/*.conf" >>/etc/dovecot/dovecot.conf 
echo "!include_try local.conf" >>/etc/dovecot/dovecot.conf 

}


function dovecot10mail() {

sudo rm -R /etc/dovecot/conf.d/10-mail.conf 


echo "     mail_location = mbox:~/mail:INBOX=/var/mail/%u " >> /etc/dovecot/conf.d/10-mail.conf 
echo " " >> /etc/dovecot/conf.d/10-mail.conf 
echo "namespace inbox { " >> /etc/dovecot/conf.d/10-mail.conf 
echo " " >> /etc/dovecot/conf.d/10-mail.conf 
echo "  inbox = yes " >> /etc/dovecot/conf.d/10-mail.conf 
echo " " >> /etc/dovecot/conf.d/10-mail.conf 
echo " " >> /etc/dovecot/conf.d/10-mail.conf 
echo "}" >> /etc/dovecot/conf.d/10-mail.conf 
echo " " >> /etc/dovecot/conf.d/10-mail.conf 
echo " " >> /etc/dovecot/conf.d/10-mail.conf 
echo "mbox_write_locks = fcntl" >> /etc/dovecot/conf.d/10-mail.conf 
echo " " >> /etc/dovecot/conf.d/10-mail.conf 

}

function dovecot10auth() {

sudo rm -R /etc/dovecot/conf.d/10-auth.conf 

 a="/etc/dovecot/conf.d/10-auth.conf "
#------------------------------------------------


echo "## " >>$a
echo "## Authentication processes" >>$a
echo "##" >>$a
echo "" >>$a
echo "# Disable LOGIN command and all other plaintext authentications unless" >>$a
echo "# SSL/TLS is used (LOGINDISABLED capability). Note that if the remote IP" >>$a
echo "# matches the local IP (ie. you're connecting from the same computer), the" >>$a
echo "# connection is considered secure and plaintext authentication is allowed." >>$a
echo "# See also ssl=required setting." >>$a
echo "disable_plaintext_auth = no" >>$a
echo " " >>$a
echo "# Authentication cache size (e.g. 10M). 0 means it's disabled. Note that" >>$a
echo "# bsdauth, PAM and vpopmail require cache_key to be set for caching to be used." >>$a
echo "#auth_cache_size = 0" >>$a
echo "# Time to live for cached data. After TTL expires the cached record is no" >>$a
echo "# longer used, *except* if the main database lookup returns internal failure." >>$a
echo "# We also try to handle password changes automatically: If user's previous" >>$a
echo "# authentication was successful, but this one wasn't, the cache isn't used." >>$a
echo "# For now this works only with plaintext authentication." >>$a
echo "#auth_cache_ttl = 1 hour" >>$a
echo "# TTL for negative hits (user not found, password mismatch)." >>$a
echo "# 0 disables caching them completely." >>$a
echo "#auth_cache_negative_ttl = 1 hour" >>$a
echo "" >>$a
echo "# Space separated list of realms for SASL authentication mechanisms that need" >>$a
echo "# them. You can leave it empty if you don't want to support multiple realms." >>$a
echo "# Many clients simply use the first one listed here, so keep the default realm " >>$a
echo "# first." >>$a
echo "#auth_realms =" >>$a
echo "" >>$a
echo "# Default realm/domain to use if none was specified. This is used for both" >>$a
echo "# SASL realms and appending @domain to username in plaintext logins." >>$a
echo "#auth_default_realm = " >>$a
echo "" >>$a
echo "# List of allowed characters in username. If the user-given username contains" >>$a
echo "# a character not listed in here, the login automatically fails. This is just" >>$a
echo "# an extra check to make sure user can't exploit any potential quote escaping" >>$a
echo "# vulnerabilities with SQL/LDAP databases. If you want to allow all characters," >>$a
echo "# set this value to empty." >>$a
echo "#auth_username_chars = echo" >>$a "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890.-_@" >>$a
echo "" >>$a
echo "# Username character translations before it's looked up from databases. The" >>$a
echo "# value contains series of from -> to characters. For example "#@/@" means" >>$a
echo "# that '#' and '/' characters are translated to '@'." >>$a
echo "#auth_username_translation =" >>$a
echo "" >>$a
echo "# Username formatting before it's looked up from databases. You can use" >>$a
echo "# the standard variables here, eg. %Lu would lowercase the username, %n would" >>$a
echo "# drop away the domain if it was given, or "%n-AT-%d" would change the '@' into" >>$a
echo "# "-AT-". This translation is done after auth_username_translation changes." >>$a
echo "#auth_username_format = %Lu" >>$a
echo "" >>$a
echo "# If you want to allow master users to log in by specifying the master" >>$a
echo "# username within the normal username string (ie. not using SASL mechanism's" >>$a
echo "# support for it), you can specify the separator character here. The format" >>$a
echo "# is then <username><separator><master username>. UW-IMAP uses "*" as the" >>$a
echo "# separator, so that could be a good choice." >>$a
echo "#auth_master_user_separator =" >>$a
echo "" >>$a
echo "# Username to use for users logging in with ANONYMOUS SASL mechanism" >>$a
echo "#auth_anonymous_username = anonymous" >>$a
echo "" >>$a
echo "# Maximum number of dovecot-auth worker processes. They're used to execute" >>$a
echo "# blocking passdb and userdb queries (eg. MySQL and PAM). They're" >>$a
echo "# automatically created and destroyed as needed." >>$a
echo "#auth_worker_max_count = 30" >>$a
echo "" >>$a
echo "# Host name to use in GSSAPI principal names. The default is to use the" >>$a
echo "# name returned by gethostname(). Use "$ALL" (with quotes) to allow all keytab" >>$a
echo "# entries." >>$a
echo "#auth_gssapi_hostname =" >>$a
echo "" >>$a
echo "# Kerberos keytab to use for the GSSAPI mechanism. Will use the system" >>$a
echo "# default (usually /etc/krb5.keytab) if not specified. You may need to change" >>$a
echo "# the auth service to run as root to be able to read this file." >>$a
echo "#auth_krb5_keytab = " >>$a
echo "" >>$a
echo "# Do NTLM and GSS-SPNEGO authentication using Samba's winbind daemon and" >>$a
echo "# ntlm_auth helper. <doc/wiki/Authentication/Mechanisms/Winbind.txt>" >>$a
echo "#auth_use_winbind = no" >>$a
echo "" >>$a
echo "# Path for Samba's ntlm_auth helper binary." >>$a
echo "#auth_winbind_helper_path = /usr/bin/ntlm_auth" >>$a
echo "" >>$a
echo "# Time to delay before replying to failed authentications." >>$a
echo "#auth_failure_delay = 2 secs" >>$a
echo "" >>$a
echo "# Require a valid SSL client certificate or the authentication fails." >>$a
echo "#auth_ssl_require_client_cert = no" >>$a
echo "" >>$a
echo "# Take the username from client's SSL certificate, using " >>$a
echo "# X509_NAME_get_text_by_NID() which returns the subject's DN's" >>$a
echo "# CommonName. " >>$a
echo "#auth_ssl_username_from_cert = no" >>$a
echo "" >>$a
echo "# Space separated list of wanted authentication mechanisms:" >>$a
echo "#   plain login digest-md5 cram-md5 ntlm rpa apop anonymous gssapi otp skey" >>$a
echo "#   gss-spnego" >>$a
echo "# NOTE: See also disable_plaintext_auth setting." >>$a
echo "auth_mechanisms = plain" >>$a
echo "" >>$a
echo "##" >>$a
echo "## Password and user databases" >>$a
echo "##" >>$a
echo "" >>$a
echo "#" >>$a
echo "# Password database is used to verify user's password (and nothing more)." >>$a
echo "# You can have multiple passdbs and userdbs. This is useful if you want to" >>$a
echo "# allow both system users (/etc/passwd) and virtual users to login without" >>$a
echo "# duplicating the system users into virtual database." >>$a
echo "#" >>$a
echo "# <doc/wiki/PasswordDatabase.txt>" >>$a
echo "#" >>$a
echo "# User database specifies where mails are located and what user/group IDs" >>$a
echo "# own them. For single-UID configuration use "static" userdb." >>$a
echo "#" >>$a
echo "# <doc/wiki/UserDatabase.txt>" >>$a
echo "" >>$a
echo "#!include auth-deny.conf.ext" >>$a
echo "#!include auth-master.conf.ext" >>$a
echo "" >>$a
echo "!include auth-system.conf.ext" >>$a
echo "#!include auth-sql.conf.ext" >>$a
echo "#!include auth-ldap.conf.ext" >>$a
echo "#!include auth-passwdfile.conf.ext" >>$a
echo "#!include auth-checkpassword.conf.ext" >>$a
echo "#!include auth-vpopmail.conf.ext" >>$a
echo "#!include auth-static.conf.ext" >>$a

#-------------------------------
}

function sendmail() {

echo "Escoge un dominio "
read domcore

echo "         * * * Nota para que se creen los usuarios debes logearte primero con todos los usuarios que van a usar correo ****** "


hostname $domcore


sed -i 's/dnl MASQUERADE_AS(`mydomain.com'"'"')dnl/MASQUERADE_AS(`'"$domcore"''"'"')dnl/g' "/etc/mail/sendmail.mc"

sed -i 's/DAEMON_OPTIONS(`Port=smtp,Addr=127.0.0.1, Name=MTA'"'"')dnl/dnl DAEMON_OPTIONS(`Port=submission, Name=MSA, M=Ea'"'"')dnl/g ' "/etc/mail/sendmail.mc"
sudo rm -R /etc/mail/local-host-names
echo "$domcore" >> /etc/mail/local-host-names
}




function squierl(){

sudo rm -R /etc/httpd/conf.d/squirrelmail.conf 
sq=/etc/httpd/conf.d/squirrelmail.conf 

echo "Alias /webmail /usr/share/squirrelmail" >>$sq

echo '<Directory "/usr/share/squirrelmail/plugins/squirrelspell/modules">'>>$sq
 echo ' <IfModule mod_authz_core.c>'>>$sq
  
 echo '   Require all granted'>>$sq
echo '  </IfModule>'>>$sq
echo '  <IfModule !mod_authz_core.c>'>>$sq
 
echo '    Order deny,allow'>>$sq
echo '    Deny from all'>>$sq
 echo ' </IfModule>'>>$sq
echo '</Directory>'>>$sq

echo '<Directory /usr/share/squirrelmail>'>>$sq

 echo ' <IfModule mod_authz_core.c>'>>$sq
   
  echo '  Require all granted'>>$sq
  echo '</IfModule>'>>$sq
 echo ' <IfModule !mod_authz_core.c>'>>$sq
  
echo '    Order allow,deny'>>$sq
echo '    Allow from all'>>$sq
echo '  </IfModule>'>>$sq
echo '</Directory>'>>$sq


}


function acces()
{

sudo rm -R /etc/mail/access
echo "Connect:localhost.localdomain		RELAY" >> /etc/mail/access
echo "Connect:localhost			RELAY">> /etc/mail/access
echo "Connect:127.0.0.1			RELAY">> /etc/mail/access



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
echo ""
echo ""
echo "Escoga los usuarios y use una contraseña para el samba"
echo "          "; ls /home
echo " "
read sambau 
echo " " 
echo "Escoga nombre de la carpeta "
read nombrec

sudo rm -R /etc/samba/smb.conf
echo "[global]" >>/etc/samba/smb.conf
echo "workgroup = WORKGROUP" >>/etc/samba/smb.conf
echo "server string = Samba Server %v" >>/etc/samba/smb.conf
echo "netbios name = centos" >>/etc/samba/smb.conf
echo "security = user" >>/etc/samba/smb.conf
echo "map to guest = bad user" >>/etc/samba/smb.conf
echo "dns proxy = no" >>/etc/samba/smb.conf

echo "[$nombrec]" >>/etc/samba/smb.conf
echo "path = /home" >>/etc/samba/smb.conf
echo "browsable =yes" >>/etc/samba/smb.conf
echo "writable = yes" >>/etc/samba/smb.conf
echo "guest ok = yes" >>/etc/samba/smb.conf
echo "read only = no" >>/etc/samba/smb.conf

echo "Cargando "
echo " "
smbpasswd -a $sambau

service firewalld stop
echo "espera "
service smb restart
service smb start
setenforce 0

elif [ $opcion == 4 ]
then
#correo -------------------------------------------





echo "                  Configuracion del Correo " 
sendmail
dovecot
dovecot10mail
dovecot10auth
squierl
acces
m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf	
service postfix stop
service firewalld stop
setenforce 0
service sendmail restart
service httpd restart
service dovecot restart
setsebool httpd_can_network_connect=1





























#---------------------------------------------------
else
    echo "Error "
exit 1
fi

