value_a: dw -1
value_b: db 2

start:
    mov ax, 0
    mov al, byte value_b
    cbw
    add word value_a, ax
    
    jns end
    
    not word value_a
    inc word value_a
    jmp end
    
end:
    hlt