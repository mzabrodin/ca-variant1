; 1. Одновимірні і двовимірні масиви.
; Визначити одновимірний масив довжиною 15 слів.
; Шляхом виконання коду записати значення від 1 до 15 у елементи цього масиву.
; Визначити двовимірний масив 15x10. Елемент масиву - теж слово.
; Шляхом виконання коду без використання CALL/RET записати значення X*(Y+10) у елементи цього масиву. X - рядок. Y - стовпчик

.model small
.stack 100h

.data
    array dw 15 DUP(0)

.code
main PROC
    mov ax, @data
    mov ds, ax

    mov bx, array
    mov cx, 0
    mov ax, 1

array_loop: 
    mov [bx], ax
    inc ax
    add bx, 2
    inc cx
    cmp cx, 15
    jl array_loop

    mov ax, 4C00h
    int 21h
main ENDP
END main
