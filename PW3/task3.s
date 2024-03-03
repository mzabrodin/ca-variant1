value_a: dw 10
value_b: dw 10

start:
    mov ax, word value_a
    and ax, word value_b
    xor ax, word value_b
    
    jz true
    mov word value_a, 0
    jmp end
    
true:
    mov word value_a, 1
    
end:
    hlt