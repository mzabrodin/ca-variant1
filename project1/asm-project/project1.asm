.model small
.stack 100h

.data
    substring db "is", 0
    lines db "This is isa sample string.", 0

.code
main:
    mov ax, @data
    mov ds, ax

    ; Initialize pointers
    lea si, lines
next_line:
    ; Check for end of lines
    cmp byte ptr [si], 0
    je exit_program

    ; Count occurrences of the substring in the current line
    mov cx, 0 ; reset counter
    mov di, offset substring ; point di to the beginning of the substring
count_occurrences:
    mov al, [si] ; load current character from line
    cmp al, '$' ; check for end of line
    je print_occurrences
    mov dl, [di] ; load current character from substring
    cmp dl, '$' ; check for end of substring
    je update_counter_and_continue
    cmp al, dl ; compare current characters
    jne next_character
    inc si ; move to the next character in the line
    inc di ; move to the next character in the substring
    cmp byte ptr [di], 0 ; check if the next character in the substring is the null terminator
    je update_counter_and_continue ; if yes, increment counter and continue checking line
    jmp count_occurrences
update_counter_and_continue:
    inc cx ; increment the count of occurrences
    jmp count_occurrences
next_character:
    inc si ; move to the next character in the line
    jmp count_occurrences

print_occurrences:
    ; Convert count to ASCII
    mov al, cl
    add al, 30h ; convert to ASCII
    mov dl, al

    ; Display the count
    mov ah, 02h
    int 21h

    ; Display newline
    mov dl, 0Ah
    int 21h

    ; Move to the next line
    inc si
    jmp next_line

exit_program:
    mov ah, 4Ch
    int 21h
end main