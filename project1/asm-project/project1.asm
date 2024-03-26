.model small
.stack 100h

.data
    string_length db 0
    string db 255 dup(0)
    
    substring_length db 0
    substring db 255 dup(0)

    occurrences_length db 0
    occurrences dw 100 dup(0)
    
    word_str db 6 dup('$')

.code
main PROC
    mov ax, ds
    mov es, ax
    mov ax, @data
    mov ds, ax

    call read_argument

read_line_loop:
    call read_line
    push ax

    call count_substring_occurrences

    pop ax
    or ax, ax
    jnz read_line_loop
read_line_loop_end:

    call sort_occurrences
    call print_occurrences

end_program:
    mov ah, 4Ch
    int 21h

main ENDP

read_line PROC
    mov string_length, 0
next_char:
    mov ah, 3Fh ; read from file
    mov bx, 0h  ; stdin handle
    mov cx, 1   ; 1 byte to read
    mov dx, offset string   ; read to ds:dx
    add dl, string_length
    int 21h   ;  ax = number of bytes read

    inc string_length
    mov bx, dx
    cmp byte ptr [bx], 0Ah ; if dl == 0Ah then
    je read_line_end
    or ax, ax
    jnz next_char ; if ax != 0 then read next byte
read_line_end:
    mov byte ptr [bx], 0
    ret
read_line ENDP

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

count_substring_occurrences PROC
    xor cx, cx            ; Initialize counter for occurrences
    mov bx, offset string ; Initialize pointer to the start of the string
outer_loop:
    mov si, bx            ; Set SI to the current position in the string
    mov di, offset substring ; Set DI to the beginning of the substring
    mov dh, substring_length ; Set DH to the length of the substring
inner_loop:
    mov al, [si]         ; Load character from string
    mov ah, [di]         ; Load character from string
    cmp al, ah           ; Compare with corresponding character in substring
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
count_substring_occurrences ENDP

convert_to_string PROC
    push ax             ; Preserve AX register
    push bx             ; Preserve BX register
    push cx             ; Preserve CX register
    push si             ; Preserve SI register

    mov bx, 10          ; BX will be used as divisor

    mov di, offset word_str   ; DI points to the word_str buffer
    mov cx, 0           ; Counter for number of digits
    
convert_loop:
    xor dx, dx          ; Clear DX for division
    div bx              ; Divide AX by BX, quotient in AX, remainder in DX

    add dl, '0'         ; Convert remainder to ASCII
    mov [di], dl        ; Store ASCII digit in word_str buffer
    inc di              ; Move to next position in word_str buffer

    inc cx              ; Increment digit counter
    
    cmp ax, 0           ; Check if quotient is zero
    jnz convert_loop    ; If not, continue looping

    ; Reverse the string
    mov si, offset word_str  ; SI points to the beginning of the string
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
    mov si, offset word_str ; SI points to the beginning of the string
    add si, cx           ; Move SI to the end of the string
    mov byte ptr [si], '$'          ; Add '$' as the string terminator

    pop si               ; Restore SI register
    pop cx               ; Restore CX register
    pop bx               ; Restore BX register
    pop ax               ; Restore AX register
    ret
convert_to_string ENDP

sort_occurrences PROC             ; bubble sort algorithm of occurrences number in occurrences array
    xor cx, cx
    mov cl, occurrences_length
    dec cx            ; count-1
outerLoop:
    push cx
    lea si, occurrences
    xor cx, cx       ; Reset loop counter for inner loop
    mov cl, occurrences_length
    dec cx           ; count-1
innerLoop:
    mov ax, [si]     ; Load the count of occurrences (higher part) of current item
    mov bx, [si+2]   ; Load the count of occurrences (higher part) of next item
    cmp ah, bh       ; Compare counts
    jle nextStep     ; If the count of the next item is greater, proceed to next step
    ; Swap occurrences
    mov [si], bx     ; Store the count of occurrences of next item
    mov [si+2], ax   ; Store the count of occurrences of current item
nextStep:
    add si, 2         ; Move to the next item (each item is 4 bytes)
    loop innerLoop    ; Repeat the inner loop until all elements are compared
    pop cx            ; Restore the outer loop counter
    loop outerLoop    ; Repeat the outer loop until all elements are sorted
    ret
sort_occurrences ENDP

print_occurrences PROC
    mov si, offset occurrences
    xor cx, cx
    mov cl, occurrences_length
print_occurrences_loop:
    mov bx, [si]

    cmp bh, 0
    je print_occurrences_loop_end

    xor ax, ax
    mov al, bh
    call convert_to_string
    mov ah, 09h
    mov dx, offset word_str
    int 21h

    mov ah, 02h
    mov dl, ' '
    int 21h

    xor ax, ax
    mov al, bl
    call convert_to_string
    mov ah, 09h
    mov dx, offset word_str
    int 21h

    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

print_occurrences_loop_end:
    add si, 2
    loop print_occurrences_loop
    ret
print_occurrences ENDP

end main