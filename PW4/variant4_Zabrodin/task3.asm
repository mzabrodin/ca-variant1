;(3A: 1 бал) Скопіювати модифікований код задачі 2A.
;Замінити параметри і результат функції визначення максимуму з регістрів на використання стеку.

.model small
.stack 100h

.code
main PROC
    mov ax, @data
    mov ds, ax

    push 2
    push 3

    call find_maximum

    mov ax, 4C00h
    int 21h

main ENDP

find_maximum PROC
    pop bx
    pop ax

    cmp ax, bx
    jge greater
    mov ax, bx
    ret

greater:
    ret
find_maximum ENDP

END main
