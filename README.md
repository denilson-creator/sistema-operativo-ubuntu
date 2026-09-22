# Identificación de Hardware y Software en Ubuntu

## Descripción

Este trabajo fue desarrollado para el curso de Sistemas Operativos.

Se creó un script en Bash llamado `info_sistemas.sh`, cuya función es identificar los principales componentes de hardware y software de un equipo que utilice Linux/Ubuntu.

Además, el script permite observar el consumo de recursos y los procesos que se encuentran en ejecución en el momento del análisis.

## Funciones del script

El script obtiene información sobre:

### Hardware
- Procesador (CPU)
- Memoria RAM
- Almacenamiento
- Tarjeta gráfica (GPU)
- Interfaces de red

### Software
- Sistema operativo
- Versión del kernel
- Arquitectura
- Programas y paquetes instalados
- Procesos activos
- Procesos con mayor consumo de CPU
- Procesos con mayor consumo de memoria RAM

## Reporte del sistema

Al finalizar el análisis, el script genera automáticamente dos archivos:

- Un reporte en formato `.txt`
- Un reporte en formato `.html`

El reporte HTML organiza los resultados en tablas para facilitar su lectura y puede abrirse desde un navegador.

Desde el navegador también puede imprimirse o guardarse como archivo PDF.

## Ejecución

Primero se deben dar permisos de ejecución al script:

```bash
chmod +x info_sistemas.sh
