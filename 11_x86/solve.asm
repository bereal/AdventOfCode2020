section .bss

area:
    .width  equ (96 + 2)
    .height equ (90 + 2)
    .length equ area.width * area.height

    .phase   resb 1
    .changed resb 1
    .one    resb area.length
    .two    resb area.length


buf: resb 32

border   equ ' '
occupied equ '#'
vacant   equ 'L'
floor    equ '.'

section .data

scanner:
    .n  dd 0
        dd -area.width
    .s  dd 0
        dd area.width
    .w  dd 0
        dd -1
    .e  dd 0
        dd 1
    .nw dd 0
        dd -area.width - 1
    .ne dd 0
        dd -area.width + 1
    .sw dd 0
        dd area.width - 1
    .se dd 0
        dd area.width + 1


section .rodata
    eol: db 10


section .text

global _start

%macro push 1-*
    %rep %0
        push %1
        %rotate 1
    %endrep
%endmacro

%macro pop 1-*
    %rep %0
        %rotate -1
        pop %1
    %endrep
%endmacro

prefill:
    push ecx, edx
    mov edx, area.one
    mov ecx, area.length
    add ecx, ecx

.prefill_loop:
    mov [edx], byte border
    inc edx
    loop .prefill_loop

    pop ecx, edx
    ret

read_input:
    call prefill
    mov edx, area.height - 2
    mov ecx, area.one
    mov ecx, area.one + area.width + 1

.read_loop:
    push edx
    mov eax, 3               ; sys.read
    xor ebx, ebx
    mov edx, area.width-1    ; length ( real width + \n )
    int 80h

    add ecx, area.width-2
    mov [ecx], byte border
    add ecx, 2

    pop edx
    dec edx
    jnz .read_loop
    ret


;; eax = cell ptr
init_scanner:
    pushad
    mov esi, scanner
    mov ebx, 0
    mov ecx, 8

.init_loop:
    mov edx, eax
    add edx, [esi + ebx + 4]
    mov [esi + ebx], edx

    add ebx, 8
    loop .init_loop

    popad
    ret


scan:
    push eax, ebx, ecx, edx

.scan_search_loop:
    mov edx, scanner
    mov ecx, 8
    xor al, al

.scan_cell_loop:
    mov ebx, [edx]
    mov ah, [ebx]
    cmp ah, floor
    jne .scan_next

    inc al
    add ebx, [edx+4]
    mov [edx], ebx
.scan_next:
    add edx, 8
    loop .scan_cell_loop

    test al, al
    jnz .scan_search_loop

    pop eax, ebx, ecx, edx
    ret


count_occupied_in_scanner:
    push ebx, ecx, edx
    mov ebx, scanner
    mov ecx, 8
    xor eax, eax
.count_scanner_loop:
    mov edx, [ebx]
    mov ah, byte [edx]
    cmp ah, occupied
    jne .count_scanner_next
    inc al
.count_scanner_next:
    add ebx, 8
    loop .count_scanner_loop
    xor ah, ah
    pop ebx, ecx, edx
    ret


count_occupied:
    push ebx, ecx, edx
    mov edx, area.one
    mov al, [area.phase]
    test al, al
    jz .count_start
    mov edx, area.two

.count_start:
    xor eax, eax
    mov ecx, area.length
.count_loop:
    mov bl, [edx]
    cmp bl, occupied
    jne .count_next
    inc eax
.count_next:
    inc edx
    loop .count_loop

    pop ebx, ecx, edx
    ret


switch_phase:
    push eax
    xor eax, eax
    mov al, [area.phase]
    xor al, 1
    mov [area.phase], al
    pop eax
    ret


;; print decimal int from eax
print_decimal:
    pusha
    mov ecx, buf

    mov ebx, 10000
    call .print_add_digit
    mov ebx, 1000
    call .print_add_digit
    mov ebx, 100
    call .print_add_digit
    mov ebx, 10
    call .print_add_digit
    add al, '0'
    mov [ecx], al
    inc ecx
    jmp .print_out

.print_add_digit:
    xor edx, edx
    div ebx
    add al, '0'
    mov [ecx], al
    mov eax, edx
    inc ecx
    ret

.print_out:
    mov [ecx], byte 10
    mov edx, 6
    mov ecx, buf

.print_remove_trailing_loop:
    xor eax, eax
    mov al, [ecx]
    cmp al, '0'
    jne  .print_call
    inc ecx
    dec edx
    jmp .print_remove_trailing_loop

.print_call:
    mov eax, 4  ; sys_write
    mov ebx, 1
    int 80h

    popa
    ret


print_map:
    pusha
    mov ebx, area.height

    mov ecx, area.one
    mov al, [area.phase]
    test al, al
    jz .print_start
    mov ecx, area.two

.print_start:
    push ebx, ecx
    mov edx, area.width
    mov eax, 4
    mov ebx, 1
    int 80h

    mov ecx, eol
    mov eax, 4
    mov edx, 1
    int 80h
    pop ebx, ecx

    add ecx, area.width
    dec ebx
    jnz .print_start

    popa
    ret


one_step:
    pusha
    xor ecx, ecx

    mov bh, area.height-2  ; row
    mov bl, area.width-2   ; col
    mov edx, (area.height-2) * area.width + area.width - 2

    mov esi, area.one
    mov edi, area.two

    mov al, [area.phase]
    test al, al
    jz .step_start
    xchg esi, edi

.step_start:
    mov cl, [esi + edx]
    cmp cl, border
    je .step_loop_next

    cmp cl, floor
    je .step_update

    lea eax, [esi + edx]
    call init_scanner
%ifenv PART2
    call scan
%endif
    call count_occupied_in_scanner

    cmp cl, occupied
    jne .step_not_occcupied
%ifenv PART2
    cmp al, 5
%else
    cmp al, 4
%endif

    jl .step_update
    mov ch, 1
    mov cl, vacant
    jmp .step_loop_next

.step_not_occcupied:
    cmp cl, vacant
    jne .step_update
    test al, al
    jnz .step_update
    mov ch, 1
    mov cl, occupied

.step_update:
    mov [edi + edx], cl

.step_loop_next:
    dec edx
    dec bl
    jnz .step_start

    mov bl, area.width-2
    sub edx, 2

    dec bh
    jnz .step_start

    call switch_phase
    test ch, ch
    popa
    ret


_start:
    mov [area.phase], byte 0
    call read_input

converge_loop:
    call one_step
    call one_step
    jnz converge_loop

    call count_occupied
    test eax, eax
    jz exit
    call print_decimal

exit:
    mov eax, 1
    xor ebx, ebx
    int 80h
