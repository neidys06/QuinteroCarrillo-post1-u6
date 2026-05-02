; lab6_factorial.asm — Variante factorial: calcula 5! = 120
; Compilar: nasm -f bin lab6_factorial.asm -o ../b/lab6_fact.com

org 100h

jmp inicio
valor_a  dw 45
valor_b  dw 12

inicio:
    ; Bucle factorial: 5! = 5*4*3*2*1 = 120
    MOV ax, 1       ; AX = 1 (acumulador, inicio en 1)
    MOV cx, 5       ; CX = contador del bucle
    MOV bx, 5       ; BX = valor inicial a multiplicar

.bucle_fact:
    MUL bx          ; AX = AX * BX
    DEC bx          ; BX-- (siguiente valor)
    LOOP .bucle_fact ; DEC CX; si CX!=0 repetir
    ; AX = 120 al terminar

    INT 20h