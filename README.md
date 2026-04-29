# Laboratorio: Manejo de Pantalla y Teclado en x86 Assembly

* **Estudiante:** Juan Carlos Barajas Quintero 
* **Curso:** Arquitectura de Computadores - Unidad 7
* **Institución:** Universidad Francisco de Paula Santander

## Descripción del Laboratorio
Este laboratorio consiste en la implementación de programas en ensamblador x86 diseñados para el control de bajo nivel de los periféricos de entrada y salida. El objetivo principal es aprender a:
*   **Leer el teclado** mediante la interrupción **INT 16h**, permitiendo distinguir entre *scan codes* (códigos de hardware) y caracteres ASCII.
*   **Controlar la pantalla** mediante el acceso directo al segmento de video **B800h**, gestionando texto y color sin depender de las interrupciones del BIOS.

### Entorno de Trabajo
Para el cumplimiento de los objetivos, se utilizó el siguiente software y versiones:
*   **Emulador:** DOSBox 0.74+.
*   **Ensamblador:** NASM versión 2.14+.
*   **Control de Versiones:** Git para la gestión del repositorio.
*   **Editor de Texto:** VS code para la escritura de los archivos .asm.

## Arquitectura de la Solución
La arquitectura del proyecto se basa en la interacción directa con la memoria y los servicios del BIOS en modo real:

1.  **Gestión de Entrada (Teclado):** Se utiliza la interrupción **INT 16h** para acceder al buffer circular del teclado en el área de datos del BIOS (BDA, segmento 0040h). El sistema captura el par `AH:AL`, donde `AH` contiene el *scan code* de la tecla y `AL` el carácter ASCII.
2.  **Gestión de Salida (Video):** Se opera en modo texto 80x25, donde el adaptador VGA mapea la memoria visible en el segmento **B800h**. La solución escribe directamente en esta memoria para obtener un rendimiento óptimo y control total sobre los atributos visuales.
3.  **Procesamiento de Datos:** Los programas calculan dinámicamente las posiciones de memoria para colocar caracteres y aplican máscaras de bits para definir colores de fondo y frente.

## Conceptos Usados en la Implementación

### 1. Fórmula de Cálculo de Offset
Para posicionar un carácter en una pantalla de 80 columnas por 25 filas, se utiliza la siguiente fórmula, considerando que cada celda ocupa **2 bytes** (carácter + atributo):

`offset = (fila * 80 + columna) * 2`

*   **Ejemplo:** Para escribir en la fila 10, columna 35, el offset resultante es `(10 * 80 + 35) * 2 = 1670`.
*   El byte del **carácter** se ubica en `B800h:offset`.
*   El byte del **atributo** se ubica en `B800h:offset + 1`.

### 2. Estructura del Byte de Atributo
El color y comportamiento de cada carácter se define mediante un byte de atributo con la siguiente estructura de 8 bits:
*   **Bits 7-4 (Fondo):** Definen el color de fondo de la celda.
*   **Bits 3-0 (Texto):** Definen el color del carácter (primer plano).

**Ejemplo de atributo:** El valor `17h` (0001 0111b) representa un fondo azul oscuro con texto blanco.

## Componentes del Proyecto (Checkpoints)
El laboratorio se divide en cuatro fases funcionales documentadas en el código:
1.  **Lectura de Scan Codes:** Bucle de captura de teclas que muestra códigos hexadecimales hasta presionar ESC.
2.  **Escritura Directa:** Impresión de caracteres individuales en coordenadas específicas calculando offsets manuales.
3.  **Relleno de Región:** Uso de la instrucción eficiente `REP STOSW` para limpiar la pantalla o pintar fondos uniformes.
4.  **Mini Editor:** Integración de teclado y video para mostrar texto en pantalla en tiempo real con avance de cursor.

