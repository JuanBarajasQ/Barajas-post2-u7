; post2d.asm - Mini editor: INT 16h + B800h
ORG 100h

section .data
 fila equ 12 ; fila fija de edición
 col_ini equ 0 ; columna inicial
 atributo equ 0Fh ; blanco brillante sobre negro

section .text

start:
 mov ax, 0B800h
 mov es, ax

 ; col actual en DL
 mov dl, col_ini

.leer:
 mov ah, 00h
 int 16h ; AH = scan, AL = ASCII

 cmp al, 0Dh ; Enter?
 je .fin
 cmp bl, 01h ; (nota: AH en BL si se requiere scan)
 ; Para simplificar solo usamos AL (no extendidas)
 or al, al
 jz .leer ; tecla extendida, ignorar

 ; Calcular offset = (fila*80 + col)*2
 movzx bx, dl ; BX = columna actual
 mov ax, fila
 imul ax, 80
 add ax, bx
 shl ax, 1 ; ×2
 mov di, ax

 ; Recuperar el carácter de AL (se perdió en imul)
 mov ah, 00h
 int 16h ; releer (simplificación didáctica)

 ; Escribir carácter y atributo
 mov byte [es:di], al
 mov byte [es:di+1], atributo
 inc dl
 cmp dl, 80
 jl .leer
 mov dl, col_ini ; volver al inicio si se llega al borde
 jmp .leer

.fin:
 mov ah, 4Ch
 xor al, al
 int 21h
