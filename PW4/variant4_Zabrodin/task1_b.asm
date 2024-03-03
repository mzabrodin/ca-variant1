;(1B: 1.5 бали) Визначити двовимірний масив 8x15. Елемент масиву - теж слово.
;Записати значення (2*X+Y) у елементи цього масиву без використання CALL/RET, де X - рядок, Y - стовпчик.

.model small
.stack 100h

.data
    array dw 8*15 dup(0)
.code
main PROC
    mov ax, @data
    mov ds, ax

    mov ch, 0; x
    mov cl, 0; y

myloop:
    xor ah, ah
    mov al, ch
    shl ax, 1; 2*x
    add al, cl; 2*x + y
    mov bx, ax; bx = 2*x + y

    mov ax, 15
    mul ch
    mov dl, cl
    xor dh, dh
    add ax, dx; 15*x + y
    shl ax, 1
    xchg ax, bx; ax = value, bx = index

    mov [array + bx], ax
    inc cl
    cmp cl, 15
    jne myloop
    mov cl, 0
    inc ch
    cmp ch, 8
    jne myloop

    mov ax, 4C00h
    int 21h
main ENDP
END main