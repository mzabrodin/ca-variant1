model small
stack 100h

.data
    array db 15

.code
main PROC
    mov ax, @data
    mov ds, ax

;read input and write it to array
    mov cx, 15
    lea si, array
    read_input:
        mov ah, 01h
        int 21h
        mov [si], al
        inc si
        loop read_input

;write array to output
    mov cx, 15
    lea si, array
    write_output:
        mov dl, [si]
        mov ah, 02h
        int 21h
        inc si
        loop write_output
    jmp end_program

;end program
end_program:
    mov ax, 4c00h
    int 21h

main ENDP

END main