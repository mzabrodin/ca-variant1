model small
stack 100h

.code
main PROC
    mov ax, @data
    mov ds, ax
    
end_program:
    mov ax, 4c00h
    int 21h

main ENDP

END main