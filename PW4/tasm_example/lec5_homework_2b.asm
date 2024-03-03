;2. Написання процедур і функцій.
;Створити функцію віднімання двох чисел AX-BX із результатом у AX.
;Скопіювати код задачі 1.2. Винести код розрахунку X*(Y+10) у окрему функцію (повертає результат в AX).
;А код запису слова у елемент X:Y масиву - у процедуру (X:Y бере з BX і DX, значення бере з AX).

.model small
.stack 100h
.data
    array dw 15*10 DUP(0) ; Define array, initially filled with 0s

.code
main PROC
    mov ax, @data       ; Initialize data segment
    mov ds, ax

    mov ch, 0          ; Set loop counter for rows (X)
    mov cl, 0          ; Set loop counter for columns (Y)

myloop:
    call x_multiply_y_10 ; AX = (Y + 10) * X

    ; AX = value, CH = row, CL = column
    mov bl, ch
    xor bh, bh
    mov dl, cl
    xor dh, dh
    ; AX = value, BX = row, DX = column
    call store_in_array 

    inc cl
    cmp cl, 10
    jne myloop
    mov cl, 0
    inc ch
    cmp ch, 15
    jne myloop
    

    mov ax, 4C00h       ; Terminate program
    int 21h
main ENDP

x_multiply_y_10  proc ; AX = (Y + 10) * X; X = CH; Y = CL
    ; Y+10
    xor ah, ah
    mov al, cl  ; Y
    add al, 10  ; AX = Y + 10
    mov bl, ch  ; BL = X
    xor bh, bh  ; BH = 0 // so that we can use BX as a 16-bit register
    mul bx      ; AX = AX * BX  // AX = (Y + 10) * X
    ret
x_multiply_y_10 endp

store_in_array proc ; AX = value, BX = row, DX = column
    ; save AX
    push ax
    ; find the address of the element in the word array
    ; first, find the address of the row
    mov ax, 10
    push dx
    mul bx
    pop dx
    ; now add the column stored in DX
    add ax, dx
    
    ; now multiply by 2 to get the offset in the array
    shl ax, 1
    mov bx, ax
    ; restore AX
    pop ax

    ; now store the result from BX into the array
    mov [array + bx], ax
    ret
store_in_array endp
end main
