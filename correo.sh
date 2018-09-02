#!/bin/bash
echo '----------SERVIDOR DE CORREO-------------'
echo '              '

echo '1- Crear Servidor de Correo'
echo '2- Añadir usuario al Correo'
read option
if [ ${option} -eq 1 ]
then
echo " Añada Su dominio "
read string
if [ ${#string} -lt 2 ]; then echo "Dominio Demasiado pequ" ; exit
fi	
hostname ${string}
echo "----------------"
hostname
echo "---------------"
sed -i "s/#protocols = imap pop3 lmtp/protocols = imap pop3 /g" /etc/dovecot/dovecot.conf
sed -i "s/#   mail_location = mbox:~/   mail_location = mbox:~/g"  /etc/dovecot/conf.d/10-mail.conf
sed -i "s/#disable_plaintext_auth = yes/disable_plaintext_auth = no/g" /etc/dovecot/conf.d/10-auth.conf
sed -i "s/Port=smtp,Addr=127.0.0.1, Name=MTA/Port=smtp, Name=MTA/g" /etc/mail/sendmail.mc
sed -i "s/mydomain.com/${string}/g" /etc/mail/sendmail.mc

m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf


sed -i "s/Require all denied/Require all granted/g" /etc/httpd/conf.d/squirrelmail.conf

sed -i "s/RewriteEngine  on/#RewriteEngine  on/g" /etc/httpd/conf.d/squirrelmail.conf
sed -i "s/RewriteRule/#RewriteRule/g" /etc/httpd/conf.d/squirrelmail.conf
sed -i "s/RewriteCond    %{HTTPS} !=on/#RewriteCond    %{HTTPS} !=on/g" /etc/httpd/conf.d/squirrelmail.conf
cat /dev/null > /etc/mail/local-host-names 
echo ${string} >> /etc/mail/local-host-names
cat /dev/null > /etc/mail/access  
echo "Connect:localhost.localdomain		RELAY" >> /etc/mail/access
echo "Connect:localhost			RELAY" >> /etc/mail/access
echo "Connect:127.0.0.1			RELAY" >> /etc/mail/access
echo "Connect:${string}			RELAY" >> /etc/mail/access

systemctl stop postfix
systemctl restart httpd
systemctl restart sendmail
systemctl restart dovecot
systemctl stop firewalld
setenforce 0
setsebool httpd_can_network_connect=1
elif [ ${option} -eq 2 ]
then
echo "Crear Buson a usuarios"
echo "----------------"
ls /home
echo "-----------------"
read user
touch /home/${user}/mail/.imap/INBOX
cd /home/${user}
chown ${user}:mail mail -R









else
exit
fi







