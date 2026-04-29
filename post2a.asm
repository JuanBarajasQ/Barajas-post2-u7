; post2a.asm - INT 16h: leer scan codes
ORG 100h

section .data
 prompt db "Pulse una tecla (ESC para salir): $"
 msgScan db " Scan: $"
 msgAscii db " ASCII: $"
 crlf db 0Dh, 0Ah, "$"

section .text
start:
 mov ah, 09h
 mov dx, prompt
 int 21h

.leer:
 mov ah, 00h ; esperar tecla
 int 16h ; AL = ASCII, AH = scan code
 mov bl, ah ; guardar scan code en BL
 mov bh, al ; guardar ASCII en BH

 ; Verificar Escape
 cmp bl, 01h
 je .fin

 ; Mostrar "Scan: XX"
 mov ah, 09h
 mov dx, msgScan
 int 21h

 ; Imprimir scan code como 2 hex digits
 mov al, bl
 call impHex

 ; Mostrar "ASCII: XX"
 mov ah, 09h
 mov dx, msgAscii
 int 21h
 mov al, bh
 call impHex
 mov ah, 09h
 mov dx, crlf
 int 21h
 jmp .leer

.fin:
 mov ah, 4Ch
 xor al, al
 int 21h

; ---- Subrutina: imprime AL como 2 digitos hexadecimales ----
impHex:
 push ax
 mov ah, al
 shr al, 4 ; nibble alto
 call nibbleToChar
 mov ah, 09h ; INT 21h: imprimir caracter en DL
 ; usaremos INT 21h/AH=02h para imprimir un solo char
 mov dl, al
 mov ah, 02h
 int 21h
 pop ax
 and al, 0Fh ; nibble bajo
 call nibbleToChar
 mov dl, al
 mov ah, 02h
 int 21h
 ret

nibbleToChar:
 cmp al, 9
 jle .digit
 add al, 37h ; A-F: offset a letra
 ret
.digit:
 add al, 30h ; 0-9
 ret
