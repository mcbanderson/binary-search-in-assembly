title Binary Search Program (binsrch.asm)

; This program performs a binary
; search on an array.

INCLUDELIB irvine.lib                                   ; include the irvine library

.model small

.stack 100h

.data
first db 0                                              ; Beginning index for portion of array we are searching
mid db 10                                               ; Middle index for portion of array we are searching
last db 21                                              ; End index for portion of array we are searching
array db 1, 5, 6, 14, 15, 22, 23, 25, 27, 29, 45, 59, 64, 68, 88, 92, 99, 101, 113, 128, 144, 196
searchVal dw ?                                          ; The value we are searching for
prompt db "Enter the numer to search for: ", 0
successMessage db "Item located at array index: ", 0
failMessage db "Item not located in array.", 0

.code
extrn Writeint:proc, Writestring:proc, Readint:proc, Crlf:proc

main proc
    mov ax, @data                                       ; Setup the
    mov ds, ax                                          ; data segment

    mov dx, offset prompt                               ; Move prompt message into dx for printing
    call Writestring                                    ; Print prompt
    call Readint                                        ; Read input from user
    mov searchVal, ax                                   ; Store input in searchVal
    call Crlf                                           ; Move to new line on screen

L1:
    mov al, first                                       ; Move first search index into al
    cmp al, last                                        ; Compare end search index to first index
    jg L6                                               ; If last is greater than first, jump to L6

L2:
    mov al, last                                        ; Prepare to calculate new mid by moving last into al
    add al, first                                       ; Add first to last per mid calculation
    mov cl, 2                                           ; Move 2 to cl to prepare for division per mid calculation
    div cl                                              ; Divide first + last by 2 to get new mid
    mov mid, al                                         ; Store new mid value in mid

    mov si, offset array                                ; Move the array location to si
    mov ah, 00h                                         ; Zero out ah in preparation for moving to array index
    mov al, mid                                         ; Move current search index (mid) to al for moving array index
    add si, ax                                          ; Add ax (mid) to si so si points to array value we want to search
    mov al, [si]                                        ; Move item in array at mid index ([si]) to al
    cmp ax, searchVal                                   ; Compare the search value to ax (array item at index mid)
    jl L3                                               ; If ax is less than the search val, jump to L3
    jg L4                                               ; If ax is greater than the search val, jump to L4
    jmp L5                                              ; ax and searchVal are equal, so we've found the searchVal in the array. Jump to L5

L3:
    inc mid                                             ; Mid was less than the search val, so increment mid and first will get mid's value
    mov al, mid                                         ; Move value of mid to al for transfer to first
    mov first, al                                       ; Move value of al (mid) to first
    jmp L1                                              ; Repeat the search in new portion of the array. Jump to L1

L4:
    dec mid                                             ; Mid was greather than the search val, so decrement mid and last will get mid's value
    mov al, mid                                         ; Move value of mid to al for transfer to last
    mov last, al                                        ; Move value of al (mid) to last
    jmp L1                                              ; Repeat the search in new portion of the array. Jump to L1

L5:
    mov dx, offset successMessage                       ; We've found what we're looking for, so prepare to print the success message
    call Writestring                                    ; Print the success message
    mov ah, 00h                                         ; Zero out ah so we can print the correct array index that contains the search value
    mov al, mid                                         ; Put the location of the search value (mid) in al for printing
    mov bx, 10                                          ; Specify that array index should be printed in decimal format
    call Writeint                                       ; Write the array index to the console
    jmp exit                                            ; Jump to the exit of the program

L6:
    mov dx, offset failMessage                          ; We didn't find the search value in the array, so prepare to print the failure message
    call Writestring                                    ; Print the failure message

exit:
    mov ax, 4C00h                                       ; Prepare to terminate program execution and return control to DOS
    int 21h                                             ; Perform interrupt to terminate program execution
main endp

end main
