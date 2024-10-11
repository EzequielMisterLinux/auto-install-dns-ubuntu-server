#!/bin/bash

echo '
 ____             __  __ _     _            _     _                  
| __ )  _   _    |  \/  (_)___| |_ ___ _ __| |   (_)_ __  _   ___  __
|  _ \ | | | |   | |\/| | / __| __/ _ \  __| |   | |  _ \| | | \ \/ /
| |_) || |_| |   | |  | | \__ \ ||  __/ |  | |___| | | | | |_| |>  < 
|____/  \__, |   |_|  |_|_|___/\__\___|_|  |_____|_|_| |_|\__,_/_/\_\
        |___/                                                        
'
echo "Configurando red y DNS para Ubuntu Server en VirtualBox..."

if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse como root"
  exit 1
fi

STATIC_IP="10.0.2.15"
INTERFACE=$(ip -o -4 route show to default | awk '{print $5}')


cat << EOF > /etc/netplan/00-installer-config.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    $INTERFACE:
      dhcp4: no
      addresses:
        - $STATIC_IP/24
      gateway4: 192.168.1.1
      nameservers:
        addresses:
          - 127.0.0.1         
          - 8.8.8.8           
          - 8.8.4.4           
EOF

chmod 600 /etc/netplan/00-installer-config.yaml
netplan apply

apt update
apt install -y bind9 bind9utils bind9-doc

cat << EOF > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";
    listen-on { 127.0.0.1; $STATIC_IP; };
    allow-query { localhost; 10.0.2.0/24; };
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };
    dnssec-validation auto;
};
EOF

cat << EOF > /etc/bind/named.conf.local
zone "storeworld.com" {
    type master;
    file "/etc/bind/db.storeworld.com";
};
EOF

cat << EOF > /etc/bind/db.storeworld.com
\$TTL    604800
@       IN      SOA     ns1.storeworld.com. admin.storeworld.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      ns1.storeworld.com.
@       IN      A       $STATIC_IP
www     IN      A       $STATIC_IP
ns1     IN      A       $STATIC_IP
EOF

cat << EOF > /etc/systemd/resolved.conf
[Resolve]
DNS=$STATIC_IP
Domains=~storeworld.com
EOF

systemctl restart systemd-resolved
systemctl restart bind9

if systemctl is-active --quiet named; then
    echo "BIND9 se ha iniciado correctamente."
else
    echo "Error al iniciar BIND9. Verificando logs..."
    journalctl -xe --no-pager | tail -n 50
fi

echo "Configuración completada. La dirección IP estática es $STATIC_IP y el dominio www.storeworld.com ha sido configurado."
echo "Script by MisterLinux - ¡Disfruta tu nuevo servidor DNS configurado en VirtualBox!"
echo "Prueba la resolución con: nslookup www.storeworld.com $STATIC_IP"
