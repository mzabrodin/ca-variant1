;(2B: 1 бал) Скопіювати модифікований код задачі 1B. Винести код розрахунку (2*X+Y) у окрему функцію, що повертає результат у AX.
;Код запису слова у елемент X:Y масиву - у процедуру, використовуючи BX і DX для координат і AX для значення.

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
    call two_mul_x_plus_y
    
    call store_in_array
    
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

two_mul_x_plus_y PROC; ax = 2*x + y
    xor ah, ah
    mov al, ch
    shl ax, 1; 2*x
    add al, cl; 2*x + y
    ret
two_mul_x_plus_y ENDP

store_in_array PROC
    push ax; save value

    mov ax, 15
    mul ch
    mov dl, cl
    xor dh, dh
    add ax, dx; 15*x + y
    shl ax, 1
    mov bx, ax
    pop ax

    mov [array + bx], ax
    ret
store_in_array ENDP
    

END main