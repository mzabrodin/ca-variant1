; 1. Одновимірні і двовимірні масиви.
; Визначити одновимірний масив довжиною 15 слів.
; Шляхом виконання коду записати значення від 1 до 15 у елементи цього масиву.
; Визначити двовимірний масив 15x10. Елемент масиву - теж слово.
; Шляхом виконання коду без використання CALL/RET записати значення X*(Y+10) у елементи цього масиву. X - рядок. Y - стовпчик

.model small
.stack 100h
.data
    array dw 15*10 DUP(0) ; Define array, initially filled with 0s

.code
main PROC
    mov ax, @data       ; Initialize data segment
    mov ds, ax

    xor cx, cx
;cl = 0 X
;ch = 0 Y
myloop:
    ; Y+10
    xor ah, ah
    mov al, cl  ; Y
    add al, 10  ; AX = Y + 10
    mov bl, ch  ; BL = X
    xor bh, bh  ; BH = 0 // so that we can use BX as a 16-bit register
    mul bx      ; AX = AX * BX  // AX = (Y + 10) * X
    mov bx, ax  ; BX = AX

    ; find the address of the element in the word array
    ; first, find the address of the row
    mov ax, 10
    mul ch
    ; now add the column stored in CL
    mov dl, cl
    xor dh, dh
    add ax, dx
    
    ; now multiply by 2 to get the offset in the array
    shl ax, 1
    ; exhcange AX and BX so that BX contains the address of the element and AX contains the value
    xchg ax, bx

    ; now store the result from BX into the array
    mov [array + bx], ax
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
END main
