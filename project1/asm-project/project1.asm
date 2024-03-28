.model small
.stack 100h

.data
    char               db 0
    prev_char          db 0

    word_str           db 6 dup('$')    ; stores result of convert_to_string

    string_length      db 0
    string             db 255 dup(0)
    
    substring_length   db 0
    substring          db 255 dup(0)

    occurrences_length db 0
    occurrences        dw 100 dup(0)    ; high byte = occurrences, low byte = line index
    
.code
main PROC
                                mov  ax, ds
                                mov  es, ax
                                mov  ax, @data
                                mov  ds, ax

                                call read_argument

    read_line_loop:             
                                call read_line
                                push ax

                                call count_substring_occurrences

                                pop  ax
                                or   ax, ax
                                jnz  read_line_loop
    read_line_loop_end:         

                                call sort_occurrences
                                call print_occurrences

    end_program:                
                                mov  ah, 4Ch
                                int  21h

main ENDP

read_line PROC                                                      ; Read a line from the standard input
                                mov  prev_char, 0
                                mov  string_length, 0
    next_char:                  
                                mov  ah, 3Fh
                                mov  bx, 0h
                                mov  cx, 1
                                lea  dx, char
                                int  21h

                                or   ax, ax
                                jz   read_line_end

                                cmp  char, 0Ah                      ; 0Ah = '\n'
                                je   lf

                                mov  bx, offset string
                                add  bl, string_length
                                mov  al, char
                                mov  byte ptr [bx], al

                                inc  string_length
                                mov  prev_char, al
                                jmp  next_char

    lf:                         
                                cmp  prev_char, 0Dh                 ; 0Dh = '\r'
                                jne  read_line_end
                                dec  string_length
                                jmp  read_line_end
    
    read_line_end:              
                                mov  bx, offset string
                                add  bl, string_length
                                mov  byte ptr [bx], 0
                                ret
read_line ENDP


read_argument PROC                                                  ; Read the argument from the command line
                                xor  ch, ch
                                mov  cl, es:[80h]                   ; at offset 80h length of "args"
                                dec  cl
                                mov  substring_length, cl
    read_substring:             
                                test cl, cl
                                jz   read_substring_end
                                mov  si, 81h                        ; at offest 81h first char of "args"
                                add  si, cx
                                mov  bx, offset substring
                                add  bx, cx
                                mov  al, es:[si]
                                mov  byte ptr [bx-1], al
                                dec  cl
                                jmp  read_substring
    read_substring_end:         
                                ret
read_argument ENDP

count_substring_occurrences PROC                                    ; Count the number of occurrences of a substring in a string
                                xor  cx, cx
                                mov  bx, offset string
    outer_loop:                 
                                mov  si, bx
                                mov  di, offset substring
                                mov  dh, substring_length
    inner_loop:                 
                                mov  al, [si]
                                mov  ah, [di]
                                cmp  al, ah
                                jne  not_matched
                                inc  si
                                inc  di
                                dec  dh
                                jnz  inner_loop
    ; If DH becomes zero, it means the entire substring matched
                                inc  bx
                                inc  cl
    not_matched:                
                                inc  bx
                                cmp  byte ptr [bx], 0
                                jnz  outer_loop

    ; Store the total number of occurrences and return
                                mov  si, offset occurrences
                                xor  bx, bx
                                mov  bl, occurrences_length
                                shl  bl, 1
                                add  si, bx
                                mov  al, occurrences_length
                                mov  ah, cl
                                mov  [si], ax
                                inc  occurrences_length
                                ret
count_substring_occurrences ENDP

convert_to_string PROC                                              ; Convert a number in AX to a string
                                push ax
                                push bx
                                push cx
                                push si

                                mov  bx, 10

                                mov  di, offset word_str
                                mov  cx, 0
    
    convert_loop:               
                                xor  dx, dx                         ; Clear DX for division
                                div  bx                             ; Divide AX by BX, quotient in AX, remainder in DX

                                add  dl, '0'
                                mov  [di], dl
                                inc  di

                                inc  cx
    
                                cmp  ax, 0
                                jnz  convert_loop

    ; Reverse the string
                                mov  si, offset word_str            ; SI points to the beginning of the string
                                mov  di, offset word_str            ; DI holds the number of digits
                                add  di, cx
                                dec  di                             ; Decrement DI to get the index of the last character
    
    reverse_loop:               
                                cmp  si, di
                                jge  end_reverse                    ; If SI >= DI, we've reached the middle of the string
                                mov  al, [si]
                                mov  ah, [di]
                                mov  [si], ah
                                mov  [di], al
                                inc  si
                                dec  di
                                jmp  reverse_loop

    end_reverse:                
                                mov  si, offset word_str
                                add  si, cx
                                mov  byte ptr [si], '$'

                                pop  si
                                pop  cx
                                pop  bx
                                pop  ax
                                ret
convert_to_string ENDP

sort_occurrences PROC                                               ; Bubble sort algorithm of occurrences number in occurrences array
                                xor  cx, cx
                                mov  cl, occurrences_length
                                dec  cx
    outerLoop:                  
                                push cx
                                lea  si, occurrences
                                xor  cx, cx
                                mov  cl, occurrences_length
                                dec  cx
    innerLoop:                  
                                mov  ax, [si]
                                mov  bx, [si+2]
                                cmp  ah, bh
                                jle  nextStep

                                mov  [si], bx
                                mov  [si+2], ax
    nextStep:                   
                                add  si, 2
                                loop innerLoop
                                pop  cx
                                loop outerLoop
                                ret
sort_occurrences ENDP

print_occurrences PROC                                              ; Print the occurrences array
                                mov  si, offset occurrences
                                xor  cx, cx
                                mov  cl, occurrences_length
    print_occurrences_loop:     
                                mov  bx, [si]

                                cmp  bh, 0
                                je   print_occurrences_loop_end

                                xor  ax, ax
                                mov  al, bh
                                call convert_to_string
                                mov  ah, 09h
                                mov  dx, offset word_str
                                int  21h

                                mov  ah, 02h
                                mov  dl, ' '
                                int  21h

                                xor  ax, ax
                                mov  al, bl
                                call convert_to_string
                                mov  ah, 09h
                                mov  dx, offset word_str
                                int  21h

                                mov  ah, 02h
                                mov  dl, 0Dh
                                int  21h
                                mov  dl, 0Ah
                                int  21h

    print_occurrences_loop_end: 
                                add  si, 2
                                loop print_occurrences_loop
                                ret
print_occurrences ENDP

end main