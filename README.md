BlockHosts
==========

Un pequeño script bash para crear archivos /etc/hosts personalizados

Este script usa las listas de MVPS, MalwareDomains, Someonecares
Yoyo List y Adway para crear un archivo hosts personalizado que bloquea
buena parte de los dominios maliciosos y de publicidad de Internet.
El script lleva consigo un sencillo instalador que a su vez automatiza
todo el proceso inicial de configuración y realiza la creación inicial
del hosts, haciendo un respaldo del archivos hosts original.

Para instalar el archivo solo necesita hacer el siguiente procedimiento:

git clone https://github.com/YukiteruAmano/BlockHosts.git

cd BlockHosts

sudo ./INSTALL

Con eso ya tendrán instalado el script.

Para ejecutar solo deben usar el comando:

blockhost.sh

O usando el path completo:

/usr/local/bin/blockhosts.sh

En ambos cosas solo se le pedirán permisos administrativos en el momento
de acceder y modificar los archivos del sistema, el resto del proceso se
hace como usuario normal.

Entre las opciones del script están:

* blockhosts.sh add hosts: Para agregar un hosts personalizado y bloquearlo
* blockhosts.sh dell hosts: Para eliminar el bloqueo a un hosts en especifico.
* blockhosts.sh restore: Para restaurar el archivo /etc/hosts a su estado original

Para desinstalar solo deberán ejecutar

sudo ./UNINSTALL
