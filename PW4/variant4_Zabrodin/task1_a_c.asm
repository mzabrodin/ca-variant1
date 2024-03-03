; 1. Одновимірні і двовимірні масиви.
;(1A: 1.5 бали) Визначити одновимірний масив довжиною 12 слів. Заповнити цей масив значеннями, що є парними числами від 2 до 24.
;(1C: +1 бал) Потім обнулити масив і заповнити його числами Фібоначчі (тобто перші 12 чисел послідовності.
;Підказка: перші два числа 0 і 1 записуємо відразу в масив без циклу, далі цікл на 10 ітерацій.
;Кожне наступне число у ряду = a[i-1] + a[i-2]).

model small
.stack 100h

.data
    array dw 12 DUP(0)

.code
main PROC
mov ax, @data
    mov ds, ax

    mov bx, array; bx = array
    mov ax, 2; ax = 3
    mov cx, 0; cx = 0

fill_in_3n_numbers:
    mov [bx], ax
    add ax, 2
    add bx, 2
    inc cx
    cmp cx, 12
    jl fill_in_3n_numbers

    xor ax, ax; ax = 0
    sub bx, 2

set_zero:
    mov [bx], ax
    sub bx, 2
    dec cx
    cmp cx, 0
    jg set_zero

    xor ax, ax; ax = 0
    xor cx, cx; cx = 0
    mov bx, array; bx = array
    mov [bx], ax; [array] = 0
    mov ax, 1; ax = 1
    add bx, 2; bx = array + 2
    inc cx; cx = 1

fill_in_by_fibonacci_numbers:
    mov [bx], ax
    add ax, [bx-2]
    add bx, 2
    inc cx
    cmp cx, 12
    jl fill_in_by_fibonacci_numbers 

    mov ax, 4C00h
    int 21h
main ENDP
END main