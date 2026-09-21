#!/bin/bash

echo "========================================"
echo "   INFORMACION DEL SISTEMA UBUNTU"
echo "========================================"

echo
echo "===== SISTEMA OPERATIVO ====="
grep PRETTY_NAME /etc/os-release
echo "Kernel: $(uname -r)"
echo "Arquitectura: $(uname -m)"

echo
echo "===== PROCESADOR CPU ====="
lscpu | grep -E "CPU\(s\)|Nombre del modelo|Model name" | head -3

echo
echo "===== MEMORIA RAM ====="
free -h

echo
echo "===== ALMACENAMIENTO ====="
lsblk

echo
echo "===== USO DEL DISCO ====="
df -h /

echo
echo "===== TARJETA GRAFICA GPU ====="
lspci | grep -Ei "VGA|3D|Display"

echo
echo "===== PROCESOS CON MAYOR USO DE CPU ====="
ps aux --sort=-%cpu | head -6

echo
echo "===== PROCESOS CON MAYOR USO DE RAM ====="
ps aux --sort=-%mem | head -6

echo
echo "========================================"
echo "       FIN DEL REPORTE"
echo "========================================"

