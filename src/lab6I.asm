; lab6_instrucciones.asm — Demostracion de categorias de instrucciones x86
; Estudiante: Neidys Mariana Quintero Carrillo
; Compilar: nasm -f bin lab6_instrucciones.asm -o ../bin/lab6_instrucciones.com

org 100h        ; offset de inicio para archivos .COM

; ── Datos ────────────────────────────────────────────────────────────────
jmp inicio      ; saltar sobre los datos al codigo

valor_a  dw 45  ; primer operando
valor_b  dw 12  ; segundo operando
resultado dw 0  ; almacena resultado
contador db 5   ; contador de bucle
mascara  db 0Fh ; mascara de 4 bits bajos

; ── Codigo ───────────────────────────────────────────────────────────────
inicio:

; ── BLOQUE 1: Transferencia de datos ─────────────────────────────────────
    ; MOV: carga valor de memoria a registro
    MOV ax, [valor_a]   ; AX = 45
    MOV bx, [valor_b]   ; BX = 12

    ; MOV entre registros
    MOV cx, ax          ; CX = AX = 45
    MOV dx, bx          ; DX = BX = 12

    ; LEA: carga la direccion, no el contenido
    LEA si, [valor_a]   ; SI = direccion de valor_a
    MOV ax, [si]        ; AX = mem[SI] = 45

    ; XCHG: intercambio de registros
    XCHG cx, dx         ; CX=12, DX=45
    XCHG cx, dx         ; restaurar: CX=45, DX=12

    ; PUSH/POP: preservar y restaurar
    PUSH ax             ; guarda AX=45 en pila
    MOV ax, 0FFFFh      ; modifica AX temporalmente
    POP ax              ; restaura AX=45

; ── BLOQUE 2: Operaciones aritmeticas ────────────────────────────────────
    ; ADD: suma
    MOV ax, [valor_a]   ; AX = 45
    ADD ax, [valor_b]   ; AX = 45 + 12 = 57
    MOV [resultado], ax ; guarda 57 en memoria

    ; SUB: resta
    MOV ax, [valor_b]   ; AX = 12
    SUB ax, [valor_a]   ; AX = 12 - 45 = -33 (SF=1)

    ; INC y DEC
    MOV ax, [valor_a]   ; AX = 45
    INC ax              ; AX = 46
    DEC ax              ; AX = 45

    ; MUL: multiplicacion sin signo
    MOV al, 10          ; AL = 10
    MOV bl, 7           ; BL = 7
    MUL bl              ; AX = 70

    ; DIV: division
    MOV ax, 100         ; AX = 100
    MOV bl, 7           ; BL = 7
    DIV bl              ; AL=14, AH=2

; ── BLOQUE 3: Operaciones logicas ────────────────────────────────────────
    MOV al, 0B7h        ; AL = 1011 0111b

    ; AND: conserva solo 4 bits bajos
    AND al, [mascara]   ; AL = 07h

    MOV al, 0B7h        ; restaurar AL
    ; OR: activa bits altos
    OR  al, 0F0h        ; AL = F7h

    MOV al, 0AAh        ; AL = 1010 1010b
    ; XOR: inversion selectiva
    XOR al, 0FFh        ; AL = 55h

    ; XOR reg,reg: poner a cero eficientemente
    XOR bx, bx          ; BX = 0

    ; TEST: AND sin guardar resultado
    MOV al, 0B7h
    TEST al, 01h        ; ZF=0 si bit 0 = 1

    ; SHL/SHR: desplazamiento de bits
    MOV al, 08h         ; AL = 8
    SHL al, 2           ; AL = 32
    SHR al, 1           ; AL = 16

; ── BLOQUE 4: Control de flujo ───────────────────────────────────────────
    ; Estructura if/else: comparar valor_a con valor_b
    MOV ax, [valor_a]   ; AX = 45
    CMP ax, [valor_b]   ; 45 - 12 = 33 > 0
    JG  .mayor          ; salta si AX > valor_b
    JE  .igual          ; salta si AX == valor_b
    XOR cx, cx          ; CX = 0: menor
    JMP .fin_cmp

.mayor:
    MOV cx, 1           ; CX = 1: valor_a > valor_b
    JMP .fin_cmp

.igual:
    MOV cx, 2           ; CX = 2: igualdad

.fin_cmp:
    ; Bucle: suma acumulada 1+2+3+4+5 = 15
    XOR ax, ax          ; AX = 0 (acumulador)
    MOV cx, 5           ; CX = contador
    MOV bx, 1           ; BX = valor inicial

.bucle_suma:
    ADD ax, bx          ; AX += BX
    INC bx              ; BX++
    LOOP .bucle_suma    ; DEC CX; si CX!=0 repetir
    ; AX = 15 al terminar

    INT 20h             ; retornar a DOS