# dns
Script experimental


Paso 1

sudo chmod ugo+wrx azre.sh

Paso 2  

./azre.sh

Observaciones

Tener instalado named y httpd

al ser experimental solo acepta ip de este formato para ip de servidor
192.168.10.23 este tipo de ip si funciona 

192.168.1.2 este no funcionaria por la cantidad de caracteres que tiene el valor puede cambiar a cualquier ip solo no funciona por la cantidad de caracteres que tiene 

este seria incorrecto (se solucionaria de manera manual entrando a /var/named/reverse y cambiar los digitos )





23 IN PTR  dns.cruz.cr.
23 IN PTR CLIENT 
