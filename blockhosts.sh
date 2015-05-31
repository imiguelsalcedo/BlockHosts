#!/bin/bash

BLOCK='0.0.0.0 '

# Funcion de inicializacion
function init_blockhost() {
if [ "$1" == "add" ]; then
    add_hosts $2
elif [ "$1" == "del" ]; then
    del_hosts $2
elif [ "$1" == "restore" ]; then
    restore_hosts
else
    create_backup
    create_blockhosts
fi
}

# Respaldamos el archivo original /etc/hosts
function create_backup() {
if [ ! -f /etc/hosts.bak ]; then
    echo "Realizando respaldo del /etc/hosts original"
    echo "La operacion requiere de persmisos administrativos para ser realizada"
    sudo bash -c "cp /etc/hosts /etc/hosts.bak"
    echo "Repaldo realizado. Ubicacion: /etc/hosts.bak"
fi
}

# Agregamos el bloqueo de un hosts
function add_hosts() {
if [ "$1" != "" ]; then
    echo "Añadiendo host. Se requiere de permisos administrativos para realizar la operacion"
    sudo bash -c "echo $BLOCK $1 >> /etc/hosts"
else
    echo "Argumento del hosts incorrecto. Verifique."
    echo "Ej: blockhosts.sh add hosts-a-bloquear"
fi
}

# Eliminamos el bloqueo de un hosts
function del_hosts() {
if [ $1 != "" ]; then
    echo "Borrando host. Se requiere de permisos administrativos para realizar la operacion"
    sudo bash -c "sed -i '/0.0.0.0 $1/d' /etc/hosts"
else
    echo "Argumento del hosts incorrecto. Verifique."
    echo "Ej: blockhosts.sh del hosts-a-desbloquear"
fi
}

function restore_hosts (){
echo "Restaurando hosts original"
echo "Se requieren permisos administrativos para realizar la operacion"
sudo bash -c "cp /etc/hosts.bak /etc/hosts"
}

function sed_lists() {
sed -i "s/127.0.0.1/0.0.0.0/g" $1
sed -i '/#/d' $1
sed -i '/localhost/d' $1
sed -i '/broadcasthost/d' $1
sed -i '/local/d' $1
}

function create_blockhosts() {
# Descargamos las listas MVPS y MalwareDomain.
# Para agregar otras listas debe crear los comandos necesarios
echo "Descargando listas..."
cd /tmp
echo "Descargando: MalwareDomain. "
wget -q http://www.malwaredomainlist.com/hostslist/hosts.txt -O malwaredomain.txt
echo "Descargando: MVPS2002"
wget -q http://winhelp2002.mvps.org/hosts.txt -O mvps.txt
echo "Descargando: Someonewhocares"
wget -q http://someonewhocares.org/hosts/hosts -O someone.txt
echo "Descargando: Yoyo Lists"
wget -q -O yoyo_hosts.txt 'http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext'
echo "Descargando: Adway Lists"
wget -q https://adaway.org/hosts.txt -O adway.txt

# Usamos sed para eliminar las lineas que no queremos
echo "Listas descargadas. Limpiando..."
sed_lists mvps.txt
sed_lists someone.txt
sed_lists malwaredomain.txt
sed_lists yoyo_hosts.txt
sed_lists adway.txt
# Recreamos el archivo hosts
echo "Recreando archivo /etc/hosts"
fecha=`date`
echo "# Lista de bloqueo por Blockhost" > hosts
echo "# Generada en fecha: $fecha" >> hosts
cat /etc/hosts.bak >> hosts
cat yoyo_hosts.txt adway.txt malwaredomain.txt someone.txt mvps.txt > host_tmp
awk '!x[$0]++' host_tmp >> hosts

# Movemos el nuevo archivo a su posicion final
echo "Copiando nuevo archivo /etc/hosts."
echo "La operacion requiere de persmisos administrativos"
sudo bash -c "mv -v hosts /etc/hosts"

# Borramos las listas originales
echo "Borrando temporales..."
rm malwaredomain.txt mvps.txt someone.txt yoyo_hosts.txt adway.txt host_tmp

# Proceso terminado
echo "Blockhost ha terminado. Archivo /etc/hosts creado."
}

init_blockhost $1 $2
