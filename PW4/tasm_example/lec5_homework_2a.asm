;2. Написання процедур і функцій.
;Створити функцію віднімання двох чисел AX-BX із результатом у AX.
;Скопіювати код задачі 1.2. Винести код розрахунку X*(Y+10) у окрему функцію (повертає результат в AX).
;А код запису слова у елемент X:Y масиву - у процедуру (X:Y бере з BX і DX, значення бере з AX).


.model small
.stack 100h

.code
main PROC
    mov ax, 10
    mov bx, 20
    call sub_bx_from_ax

    mov ax, 4C00h       ; Terminate program
    int 21h
main ENDP

sub_bx_from_ax PROC
    sub ax, bx
    ret
sub_bx_from_ax endp

end main