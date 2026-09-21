# Identificación de Hardware y Software en Ubuntu

## Descripción

Este trabajo consiste en la creación de un script en Bash que permite identificar información del hardware y software de un sistema operativo Ubuntu mientras se encuentra en funcionamiento.

Para realizar el trabajo se utilizó Ubuntu mediante una máquina virtual en VirtualBox.

## Objetivo

Identificar los principales componentes de hardware y observar algunos recursos de software y procesos que se ejecutan en Ubuntu mediante comandos de Linux agrupados en un script Bash.

## Información que muestra el script

El script permite obtener información sobre:

- Sistema operativo y versión.
- Kernel y arquitectura.
- Procesador (CPU).
- Memoria RAM.
- Almacenamiento y uso del disco.
- Tarjeta gráfica (GPU).
- Procesos con mayor consumo de CPU.
- Procesos con mayor consumo de memoria RAM.

## Ejecución

Primero se otorgan permisos de ejecución al archivo:

```bash
chmod +x info_sistemas.sh
