;3. Скопіювати код задачі 2.1. Замінити параметри і результат виконання із використання регістрів на використання стеку.

.model small
.stack 100h

.code
main PROC
    push 20 ; 2nd argument
    push 10 ; 1st argument
    call sub_1st_from_2nd

    mov ax, 4C00h       ; Terminate program
    int 21h
main ENDP

sub_1st_from_2nd PROC
    pop dx ; save return address
    pop bx ; pop 1st argument
    pop ax ; pop 2nd argument
    push dx ; restore return address
    sub ax, bx ; ax = ax - bx
    ret
sub_1st_from_2nd endp

end main