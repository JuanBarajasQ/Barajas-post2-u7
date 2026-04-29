; post2b.asm - Escritura directa en B800h
ORG 100h

section .text
start:

 ; Apuntar ES al segmento de video
 mov ax, 0B800h
 mov es, ax

 ; Calcular offset para fila=10, col=35
 ; offset = (10*80 + 35) * 2 = (800+35)*2 = 1670
 mov di, 1670 ; DI = offset calculado

 ; Escribir carácter ASCII "H" = 48h
 mov byte [es:di], 48h ; carácter ASCII "H"
 mov byte [es:di+1], 0Fh ; atributo: blanco brillante sobre negro

 ; fila=11, col=35 -> (11*80+35)*2 = 1830
 mov di, 1830
 mov byte [es:di], 4Fh ; "O"
 mov byte [es:di+1], 0Eh ; amarillo sobre negro
 
 ; fila=12, col=35 -> (12*80+35)*2 = 1990
 mov di, 1990
 mov byte [es:di], 4Ch ; "L"
 mov byte [es:di+1], 0Ah ; verde claro sobre negro
 
 ; fila=13, col=35 -> (13*80+35)*2 = 2150
 mov di, 2150
 mov byte [es:di], 41h ; "A"
 mov byte [es:di+1], 0Ch ; rojo claro sobre negro
 
 ; Esperar tecla y salir
 mov ah, 07h
 int 21h
 mov ah, 4Ch
 xor al, al
 int 21h
