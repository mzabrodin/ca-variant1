;(2A: 1 бал) Створити функцію визначення максимуму з двох чисел, де AX містить перше число,
;BX містить друге число, а результат (більше з двох чисел) зберігається у AX.

.model small
.stack 100h

.code
main PROC
    mov ax, @data
    mov ds, ax

    mov ax, 2
    mov bx, 3

    call find_maximum

    mov ax, 4C00h
    int 21h

main ENDP

find_maximum PROC
    cmp ax, bx
    jge greater
    mov ax, bx
    ret

greater:
    ret

find_maximum ENDP

END main
