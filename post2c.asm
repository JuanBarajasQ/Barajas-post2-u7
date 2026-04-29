; post2c.asm - Limpiar pantalla con REP STOSW en B800h
ORG 100h

section .text

start:

 mov ax, 0B800h
 mov es, ax

 ; AX = atributo(fondo azul=1, texto blanco=7 -> 17h) + espacio(20h)
 ; Formato AX: AH = atributo, AL = caracter ASCII
 mov ax, 1720h ; 17h = 0001 0111b: azul oscuro fondo, blanco texto
               ; 20h = espacio ASCII

 xor di, di ; DI = offset 0 (inicio de la pantalla)
 mov cx, 2000 ; 80 columnas × 25 filas = 2000 caracteres
 cld ; dirección hacia adelante (DF=0)
 rep stosw ; almacenar AX en ES:DI, avanzar DI+2, CX-1

 ; Escribir un mensaje en el centro (fila 12, col 30)
 ; offset = (12*80 + 30)*2 = 1980
 mov di, 1980
 mov si, titulo

.bucle:
 lodsb ; AL = [DS:SI], SI++
 or al, al ; fin de cadena nula?
 jz .fin
 mov ah, 0Fh ; atributo blanco brillante
 stosw ; guardar AX en ES:DI, DI += 2
 jmp .bucle

.fin:
 mov ah, 07h
 int 21h
 mov ah, 4Ch
 xor al, al
 int 21h

titulo: db "HOLA DESDE B800h", 0