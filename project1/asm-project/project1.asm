.model small
.stack 100h

.data
    result db 6 dup('$')
    occurrences dw 100 dup(0)

    string_length db 0
    string db 255 dup(0)
    
    substring db 255 dup(0)
    substring_length db 0
    
    
    occurrences_length db 0

.code
main PROC
    mov ax, ds
    mov es, ax
    mov ax, @data
    mov ds, ax

    call read_argument

read_line:
    mov string_length, 0
read_next:
    mov ah, 3Fh ; read from file
    mov bx, 0h  ; stdin handle
    mov cx, 1   ; 1 byte to read
    mov dx, offset string   ; read to ds:dx
    add dl, string_length
    int 21h   ;  ax = number of bytes read
    inc string_length
    mov bx, dx
    cmp byte ptr [bx], 0Ah ; if dl == 0Ah then
    je count_occurrences_substring
    or ax, ax
    jnz read_next ; if ax != 0 then read next byte
    mov byte ptr [bx], 0
    call count_occurrences_substring_m
    jmp output_occurrences

output_occurrences:
    mov si, offset occurrences
    xor cx, cx
    mov cl, occurrences_length
output_occurrences_loop:
    mov bx, [si]

    xor ax, ax
    mov al, bh
    call convert_to_string
    mov ah, 09h
    mov dx, offset result
    int 21h

    mov ah, 02h
    mov dl, ' '
    int 21h

    xor ax, ax
    mov al, bl
    call convert_to_string
    mov ah, 09h
    mov dx, offset result
    int 21h

    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    add si, 2
    loop output_occurrences_loop
    jmp end_program


count_occurrences_substring:
    mov byte ptr [bx], 0
    call count_occurrences_substring_m
    jmp read_line

end_program:
    mov ah, 4Ch
    int 21h

main ENDP

read_argument PROC
    xor ch, ch
    mov cl, es:[80h]   ; at offset 80h length of "args"
    dec cl
    mov substring_length, cl
read_substring:
    test cl, cl ; if cl == 0 then
    jz read_substring_end
    mov si, 81h        ; at offest 81h first char of "args"
    add si, cx
    mov bx, offset substring
    add bx, cx
    mov al, es:[si]
    mov byte ptr [bx-1], al
    dec cl
    jmp read_substring
read_substring_end:
    ret
read_argument ENDP

count_occurrences_substring_m PROC
    xor cx, cx            ; Initialize counter for occurrences
    mov bx, offset string ; Initialize pointer to the start of the string
outer_loop:
    mov si, bx            ; Set SI to the current position in the string
    mov di, offset substring ; Set DI to the beginning of the substring
    mov dh, substring_length ; Set DH to the length of the substring
inner_loop:
    mov al, [si]         ; Load character from string
    cmp al, [di]         ; Compare with corresponding character in substring
    jne not_matched      ; If not matching, jump to check the next substring
    inc si               ; Move to the next character in the string
    inc di               ; Move to the next character in the substring
    dec dh               ; Decrease the remaining length of the substring
    jnz inner_loop       ; If DH is not zero, continue matching
    ; If DH becomes zero, it means the entire substring matched
    inc bx
    inc cl               ; Increment occurrence counter
not_matched:
    inc bx               ; Move to the next character in the string
    cmp byte ptr [bx], 0 ; Check for the end of the string
    jnz outer_loop       ; If DL is not zero, continue searching for substring

    ; Store the total number of occurrences and return
    mov si, offset occurrences
    xor bx, bx
    mov bl, occurrences_length
    shl bl, 1
    add si, bx
    mov al, occurrences_length
    mov ah, cl
    mov [si], ax
    inc occurrences_length
    ret
count_occurrences_substring_m ENDP

convert_to_string PROC
    push ax             ; Preserve AX register
    push bx             ; Preserve BX register
    push cx             ; Preserve CX register
    push si             ; Preserve SI register

    mov bx, 10          ; BX will be used as divisor

    mov di, offset result   ; DI points to the result buffer
    mov cx, 0           ; Counter for number of digits
    
convert_loop:
    xor dx, dx          ; Clear DX for division
    div bx              ; Divide AX by BX, quotient in AX, remainder in DX

    add dl, '0'         ; Convert remainder to ASCII
    mov [di], dl        ; Store ASCII digit in result buffer
    inc di              ; Move to next position in result buffer

    inc cx              ; Increment digit counter
    
    cmp ax, 0           ; Check if quotient is zero
    jnz convert_loop    ; If not, continue looping

    ; Reverse the string
    mov si, offset result  ; SI points to the beginning of the string
    mov di, cx           ; DI holds the number of digits
    dec di               ; Decrement DI to get the index of the last character
    
reverse_loop:
    cmp si, di           ; Compare SI with DI
    jge end_reverse      ; If SI >= DI, we've reached the middle of the string
    mov al, [si]         ; Load character from start
    mov ah, [di]         ; Load character from end
    mov [si], ah         ; Swap characters
    mov [di], al         ; Swap characters
    inc si               ; Move SI forward
    dec di               ; Move DI backward
    jmp reverse_loop     ; Repeat the loop

end_reverse:
    mov si, offset result ; SI points to the beginning of the string
    add si, cx           ; Move SI to the end of the string
    mov byte ptr [si], '$'          ; Add '$' as the string terminator

    pop si               ; Restore SI register
    pop cx               ; Restore CX register
    pop bx               ; Restore BX register
    pop ax               ; Restore AX register
    ret
convert_to_string ENDP


end main