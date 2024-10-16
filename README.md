# Auto-Install DNS en Ubuntu Server

Este script automatiza la configuración de un servidor DNS en Ubuntu, convirtiendo tu IP actual en estática y utilizándola para el DNS. Es compatible con máquinas virtuales y servidores físicos.

## Características

- Conversión automática de IP dinámica a estática
- Configuración de DNS utilizando la IP estática
- Compatible con máquinas virtuales y servidores físicos
- Proceso guiado paso a paso
- Configuración automática de registros A, NS y SOA

## Requisitos previos

- Ubuntu Server (probado en versiones 24.04 LTS y posteriores)
- Acceso root o privilegios sudo
- Conexión a Internet activa

### Herramientas necesarias

Antes de comenzar, asegúrate de tener instaladas las siguientes herramientas:

```bash
sudo apt update
sudo apt install git net-tools -y
```

## Instrucciones de uso

### 1. Clonar el repositorio

Primero, clona el repositorio del proyecto:

```bash
git clone https://github.com/EzequielMisterLinux/auto-install-dns-ubuntu-server.git
cd auto-install-dns-ubuntu-server
```

### 2. Obtener la IP actual

Identifica tu IP actual y la interfaz de red en uso:

```bash
ifconfig
```

Busca la interfaz en uso (ej. `eth0`, `enp0s3`) y anota la dirección IP (`inet`).

### 3. Preparar el script

Asigna permisos de ejecución al script:

```bash
chmod +x autodns.sh
```

### 4. Ejecutar el script

Inicia el script con privilegios de superusuario:

```bash
sudo ./autodns.sh
```

Sigue las instrucciones en pantalla:
- Ingresa la IP actual que obtuviste en el paso 2
- Proporciona el nombre de dominio deseado (ej. `tudominio.com`)

El script realizará las siguientes acciones:
- Convertirá la IP ingresada en una IP estática
- Configurará el DNS usando la IP estática
- Creará los registros A, NS y SOA necesarios

### 5. Verificar la configuración

Una vez completada la instalación, verifica la configuración del DNS:

```bash
# Prueba el registro A para www
nslookup www.tudominio.com

# Verifica el servidor DNS (ns1)
nslookup ns1.tudominio.com
```

Estos comandos deberían devolver la IP estática configurada.

## Resolución de problemas

Si encuentras algún problema durante la instalación o configuración, verifica:

1. Que tienes privilegios de superusuario
2. La conexión a Internet está activa
3. No hay conflictos con configuraciones DNS existentes
4. Los puertos necesarios (53 UDP/TCP) están abiertos en el firewall

Para problemas específicos:

- **Error al convertir IP a estática**: Verifica que la información de red es correcta en `/etc/netplan/`.
- **Problemas con los registros DNS**: Revisa la configuración en `/etc/bind/` y asegúrate de que el servicio bind9 está activo.


---

Creado por [Ezequiel Campos] - [https://portafolio-ezequiel-campos.netlify.app/]