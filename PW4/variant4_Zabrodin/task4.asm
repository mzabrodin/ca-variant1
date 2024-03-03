;(4A: 1 бал) Скопіювати модифікований код задачі 3A.
;Мета: забезпечити, що функція не впливає на стан регістрів викликаючого коду.
;Додати до функції код, який:
;(А) перед виконанням функції зберігає у стек регістри, які функція змінює;
;(Б) після завершення виконання функції витягує ці регістри назад із стеку.

.model small
.stack 100h

.code
main PROC
    mov ax, @data
    mov ds, ax

    push ax; зберігаємо регістри
    push bx
    push dx

    push 2; передаємо параметри функції
    push 3

    call find_maximum

    pop dx; витягуємо регістри
    pop bx
    pop ax

    mov ax, 4C00h
    int 21h

main ENDP

find_maximum PROC
    pop dx; зберіграємо у dx адресу повернення з функції
    pop bx
    pop ax

    cmp ax, bx
    jge greater
    mov ax, bx
    push dx; повертаємо у стек адресу повернення з функції
    ret

greater:
    push dx; повертаємо у стек адресу повернення з функції
    ret
find_maximum ENDP

END main


