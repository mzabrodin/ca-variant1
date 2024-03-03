value_a: dw "a"
value_b: dw 12

start:
    ;if ((a>=48 && a<=57) || (a>=97 && a<=102 && b>10))
    ;{ a = a-48; if (a>9) a = a-39; } else { a = -1; }
    cmp word value_b, 10
    jg first
    jmp second

first:
    cmp word value_a, 102
    jg second
    
    cmp word value_a, 97
    jl second
    
    jmp true
    
second: 
    cmp word value_a, 57
    jg false
    
    cmp word value_a, 48
    jl false
    
true:
    sub word value_a, 48
    cmp word value_a, 9
    jg true2
    jmp end
    
true2:
    sub word value_a, 39
    jmp end
    
false:
    mov word value_a, -1
    jmp end

end:
hlt
    