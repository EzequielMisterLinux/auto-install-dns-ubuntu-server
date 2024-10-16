# Auto-Install DNS en Ubuntu Server

Este script automatiza la configuración de un servidor DNS en Ubuntu, convirtiendo tu IP actual en estática y utilizándola para el DNS. Es compatible con máquinas virtuales y servidores físicos.

## Características

- Conversión automática de IP dinámica a estática
- Configuración de DNS utilizando la IP estática
- Compatible con máquinas virtuales y servidores físicos
- Proceso guiado paso a paso

## Requisitos previos

- Ubuntu Server (probado en versiones 18.04 LTS y posteriores)
- Acceso root o privilegios sudo
- Conexión a Internet activa

## Instrucciones de uso

### 1. Obtener la IP actual

Antes de ejecutar el script, identifica tu IP actual:

```bash
ip addr show
```

Busca la interfaz en uso (ej. `eth0`, `enp0s3`) y anota la dirección IP (`inet`).

### 2. Preparar el script

Descarga el script y asigna permisos de ejecución:

```bash
wget https://raw.githubusercontent.com/tuusuario/autodns/main/autodns.sh
chmod +x autodns.sh
```

### 3. Ejecutar el script

Inicia el script con privilegios de superusuario:

```bash
sudo ./autodns.sh
```

Sigue las instrucciones en pantalla:
- Ingresa la IP actual que obtuviste en el paso 1
- Proporciona el nombre de dominio deseado (ej. `tudominio.com`)

### 4. Verificar la configuración

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



---

Creado por [Ezequiel Campos] - [https://portafolio-ezequiel-campos.netlify.app/]