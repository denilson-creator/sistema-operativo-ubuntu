#!/bin/bash

# ==========================================================
# SCRIPT para identificar componentes
# REPORTE DE HARDWARE Y SOFTWARE - UBUNTU / LINUX
#   Sistemas Operativos
# ==========================================================

# ---------- COLORES ----------
AZUL='\033[1;34m'
VERDE='\033[1;32m'
AMARILLO='\033[1;33m'
CYAN='\033[1;36m'
ROJO='\033[1;31m'
BLANCO='\033[1;37m'
NC='\033[0m'

# ---------- ARCHIVOS DE SALIDA ----------
FECHA_ARCHIVO=$(date +"%Y-%m-%d_%H-%M-%S")
REPORTE_TXT="reporte_sistema_${FECHA_ARCHIVO}.txt"
REPORTE_HTML="reporte_sistema_${FECHA_ARCHIVO}.html"

# ---------- FUNCIONES ----------
titulo() {
    echo -e "\n${AZUL}============================================================${NC}"
    echo -e "${BLANCO} $1${NC}"
    echo -e "${AZUL}============================================================${NC}"
}

subtitulo() {
    echo -e "\n${CYAN}► $1${NC}"
    echo "------------------------------------------------------------"
}

# ---------- DATOS GENERALES ----------
HOST=$(hostname)
USUARIO=$(whoami)
FECHA=$(date "+%d/%m/%Y %H:%M:%S")
SO=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"')
KERNEL=$(uname -r)
ARQUITECTURA=$(uname -m)

clear

echo -e "${VERDE}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║             REPORTE DEL SISTEMA LINUX                    ║"
echo "║          ANÁLISIS DE HARDWARE Y SOFTWARE                 ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo " Equipo analizado : $HOST"
echo " Usuario           : $USUARIO"
echo " Fecha             : $FECHA"
echo " Sistema operativo : $SO"
echo " Kernel            : $KERNEL"
echo " Arquitectura      : $ARQUITECTURA"

# ==========================================================
# HARDWARE
# ==========================================================

titulo "[1] COMPONENTES DE HARDWARE"

subtitulo "PROCESADOR (CPU)"

MODELO_CPU=$(lscpu | grep -m1 -E "Nombre del modelo|Model name" | cut -d: -f2- | xargs)
CPUS=$(nproc)

echo " Modelo            : $MODELO_CPU"
echo " CPU disponibles   : $CPUS"
echo " Arquitectura      : $ARQUITECTURA"

subtitulo "MEMORIA RAM"

free -h

subtitulo "ALMACENAMIENTO"

# Excluye dispositivos loop utilizados normalmente por Snap.
lsblk -e 7 -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS

echo
echo "Uso de la partición principal:"
df -h /

subtitulo "TARJETA GRÁFICA (GPU)"

GPU=$(lspci | grep -Ei "VGA|3D|Display" | head -1)

if [ -n "$GPU" ]; then
    echo " $GPU"
else
    echo " No se pudo identificar la GPU."
fi

subtitulo "RED"

echo " Interfaces disponibles:"
ip -br addr | grep -v "^lo"

# ==========================================================
# SOFTWARE
# ==========================================================

titulo "[2] COMPONENTES DE SOFTWARE"

subtitulo "SISTEMA OPERATIVO"

echo " Distribución       : $SO"
echo " Kernel             : $KERNEL"
echo " Shell actual       : ${SHELL:-No identificado}"

subtitulo "PROGRAMAS Y PAQUETES INSTALADOS"

if command -v dpkg >/dev/null 2>&1; then
    TOTAL_PAQUETES=$(dpkg-query -W -f='${binary:Package}\n' 2>/dev/null | wc -l)

    echo " Total de paquetes instalados: $TOTAL_PAQUETES"
    echo
    echo " Algunos programas conocidos detectados:"
    echo

    PROGRAMAS=(firefox chromium google-chrome libreoffice git python3 gcc g++ nano vim curl wget)

    for programa in "${PROGRAMAS[@]}"; do
        if command -v "$programa" >/dev/null 2>&1; then
            printf "  ✓ %-20s Instalado\n" "$programa"
        fi
    done
else
    echo " No se encontró el gestor de paquetes dpkg."
fi

subtitulo "PROCESOS ACTIVOS"

TOTAL_PROCESOS=$(ps -e --no-headers | wc -l)

echo " Procesos actualmente activos: $TOTAL_PROCESOS"

subtitulo "PROCESOS CON MAYOR USO DE CPU"

ps -eo pid,user,comm,%cpu,%mem --sort=-%cpu | head -11

subtitulo "PROCESOS CON MAYOR USO DE RAM"

ps -eo pid,user,comm,%cpu,%mem --sort=-%mem | head -11

# ==========================================================
# RESUMEN
# ==========================================================

titulo "[3] RESUMEN DEL ESTADO DEL SISTEMA"

RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
RAM_USADA=$(free -h | awk '/^Mem:/ {print $3}')
RAM_DISP=$(free -h | awk '/^Mem:/ {print $7}')

DISCO_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISCO_USADO=$(df -h / | awk 'NR==2 {print $3}')
DISCO_DISP=$(df -h / | awk 'NR==2 {print $4}')
DISCO_PORCENTAJE=$(df -h / | awk 'NR==2 {print $5}')

echo " Equipo             : $HOST"
echo " Sistema            : $SO"
echo " CPU disponibles    : $CPUS"
echo " RAM total          : $RAM_TOTAL"
echo " RAM utilizada      : $RAM_USADA"
echo " RAM disponible     : $RAM_DISP"
echo " Disco total        : $DISCO_TOTAL"
echo " Disco utilizado    : $DISCO_USADO ($DISCO_PORCENTAJE)"
echo " Disco disponible   : $DISCO_DISP"
echo " Procesos activos   : $TOTAL_PROCESOS"

# ==========================================================
# REPORTE TXT
# ==========================================================

{
    echo "============================================================"
    echo "        REPORTE DE HARDWARE Y SOFTWARE - LINUX"
    echo "============================================================"
    echo
    echo "Fecha: $FECHA"
    echo "Equipo: $HOST"
    echo "Usuario: $USUARIO"
    echo
    echo "---------------- INFORMACIÓN GENERAL ----------------"
    echo "Sistema operativo: $SO"
    echo "Kernel: $KERNEL"
    echo "Arquitectura: $ARQUITECTURA"
    echo
    echo "---------------- HARDWARE ----------------"
    echo
    echo "CPU:"
    echo "Modelo: $MODELO_CPU"
    echo "CPU disponibles: $CPUS"
    echo
    echo "MEMORIA:"
    free -h
    echo
    echo "ALMACENAMIENTO:"
    lsblk -e 7 -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS
    echo
    df -h /
    echo
    echo "GPU:"
    echo "$GPU"
    echo
    echo "RED:"
    ip -br addr | grep -v "^lo"
    echo
    echo "---------------- SOFTWARE ----------------"
    echo "Paquetes instalados: ${TOTAL_PAQUETES:-No disponible}"
    echo "Procesos activos: $TOTAL_PROCESOS"
    echo
    echo "Procesos con mayor uso de CPU:"
    ps -eo pid,user,comm,%cpu,%mem --sort=-%cpu | head -11
    echo
    echo "Procesos con mayor uso de RAM:"
    ps -eo pid,user,comm,%cpu,%mem --sort=-%mem | head -11
    echo
    echo "---------------- RESUMEN ----------------"
    echo "RAM total: $RAM_TOTAL"
    echo "RAM utilizada: $RAM_USADA"
    echo "RAM disponible: $RAM_DISP"
    echo "Disco total: $DISCO_TOTAL"
    echo "Disco utilizado: $DISCO_USADO ($DISCO_PORCENTAJE)"
    echo "Disco disponible: $DISCO_DISP"
} > "$REPORTE_TXT"

# ==========================================================
# REPORTE HTML
# ==========================================================

cat > "$REPORTE_HTML" <<EOF
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Reporte del Sistema Linux</title>

<style>
body {
    font-family: Arial, sans-serif;
    margin: 40px;
    background: #f4f4f4;
    color: #222;
}

.contenedor {
    max-width: 950px;
    margin: auto;
    background: white;
    padding: 35px;
    border-radius: 10px;
}

h1 {
    text-align: center;
}

h2 {
    border-bottom: 2px solid #333;
    padding-bottom: 8px;
    margin-top: 30px;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
}

th, td {
    border: 1px solid #ccc;
    padding: 10px;
    text-align: left;
}

th {
    background: #eeeeee;
}

pre {
    background: #f5f5f5;
    padding: 15px;
    overflow-x: auto;
}

.pie {
    text-align: center;
    margin-top: 40px;
    font-size: 12px;
}
</style>
</head>

<body>
<div class="contenedor">

<h1>Reporte de Hardware y Software</h1>

<table>
<tr><th>Equipo</th><td>$HOST</td></tr>
<tr><th>Usuario</th><td>$USUARIO</td></tr>
<tr><th>Fecha</th><td>$FECHA</td></tr>
<tr><th>Sistema operativo</th><td>$SO</td></tr>
<tr><th>Kernel</th><td>$KERNEL</td></tr>
<tr><th>Arquitectura</th><td>$ARQUITECTURA</td></tr>
</table>

<h2>Hardware</h2>

<table>
<tr><th>Componente</th><th>Información</th></tr>
<tr><td>Procesador</td><td>$MODELO_CPU</td></tr>
<tr><td>CPU disponibles</td><td>$CPUS</td></tr>
<tr><td>RAM total</td><td>$RAM_TOTAL</td></tr>
<tr><td>RAM utilizada</td><td>$RAM_USADA</td></tr>
<tr><td>RAM disponible</td><td>$RAM_DISP</td></tr>
<tr><td>GPU</td><td>$GPU</td></tr>
<tr><td>Disco total</td><td>$DISCO_TOTAL</td></tr>
<tr><td>Disco utilizado</td><td>$DISCO_USADO ($DISCO_PORCENTAJE)</td></tr>
<tr><td>Disco disponible</td><td>$DISCO_DISP</td></tr>
</table>

<h2>Software</h2>

<table>
<tr><th>Dato</th><th>Resultado</th></tr>
<tr><td>Sistema operativo</td><td>$SO</td></tr>
<tr><td>Kernel</td><td>$KERNEL</td></tr>
<tr><td>Paquetes instalados</td><td>${TOTAL_PAQUETES:-No disponible}</td></tr>
<tr><td>Procesos activos</td><td>$TOTAL_PROCESOS</td></tr>
</table>

<h2>Procesos con mayor uso de CPU</h2>
<pre>$(ps -eo pid,user,comm,%cpu,%mem --sort=-%cpu | head -11)</pre>

<h2>Procesos con mayor uso de RAM</h2>
<pre>$(ps -eo pid,user,comm,%cpu,%mem --sort=-%mem | head -11)</pre>

<div class="pie">
Reporte generado automáticamente por info_sistemas.sh
</div>

</div>
</body>
</html>
EOF

# ==========================================================
# FINAL
# ==========================================================

titulo "REPORTE FINALIZADO"

echo -e "${VERDE}✓ Análisis completado correctamente.${NC}"
echo
echo "Se generaron los siguientes archivos:"
echo
echo "  TXT  : $REPORTE_TXT"
echo "  HTML : $REPORTE_HTML"
echo
echo -e "${AMARILLO}Para abrir el reporte HTML:${NC}"
echo "  xdg-open \"$REPORTE_HTML\""
echo
echo -e "${AMARILLO}Desde el navegador puedes usar Imprimir → Guardar como PDF.${NC}"
echo
