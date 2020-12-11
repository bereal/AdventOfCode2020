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

occupied equ '#'
vacant   equ 'L'
floor    equ '.'


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

_prefill_loop:
    mov [edx], byte '.'
    inc edx
    loop _prefill_loop

    pop ecx, edx
    ret

read_input:
    call prefill
    mov edx, area.height - 2
    mov ecx, area.one
    mov ecx, area.one + area.width + 1
    ; push eax
    ; mov eax, area.width + 1
    ; call print_decimal
    ; pop eax

_read_loop:
    ; mov [ecx-1], byte '!'
    push edx
    mov eax, 3               ; sys_read
    xor ebx, ebx
    mov edx, area.width-1    ; length ( real width + \n )
    int 80h

    add ecx, area.width-2
    mov [ecx], byte '.'
    add ecx, 2

    pop edx
    dec edx
    jnz _read_loop
    ret


count_occupied:
    push ebx, ecx, edx
    mov edx, area.one
    mov al, [area.phase]
    test al, al
    jz _count_start
    mov edx, area.two

_count_start:
    xor eax, eax
    mov ecx, area.length
_count_loop:
    mov bl, [edx]
    cmp bl, occupied
    jne _count_next
    inc eax
_count_next:
    inc edx
    loop _count_loop

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
    call _print_add_digit
    mov ebx, 1000
    call _print_add_digit
    mov ebx, 100
    call _print_add_digit
    mov ebx, 10
    call _print_add_digit
    add al, '0'
    mov [ecx], al
    inc ecx
    jmp _print_out

_print_add_digit:
    xor edx, edx
    div ebx
    add al, '0'
    mov [ecx], al
    mov eax, edx
    inc ecx
    ret

_print_out:
    mov [ecx], byte 10
    mov edx, 6
    mov ecx, buf

_print_remove_trailing_loop:
    xor eax, eax
    mov al, [ecx]
    cmp al, '0'
    jne  _print_call
    inc ecx
    dec edx
    jmp _print_remove_trailing_loop

_print_call:
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
    jz _print_start
    mov ecx, area.two

_print_start:
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
    jnz _print_start

    popa
    ret


one_step:
    push ebp
    mov ebp, esp
    sub esp, 4
    xor eax, eax
    mov [ebp], eax

    mov ebx, area.height-2  ; row
    mov ecx, area.width-2   ; col
    mov edx, (area.height-2) * area.width + area.width-2; ; offset

    mov esi, area.one
    mov edi, area.two

    mov al, [area.phase]
    test al, al
    jz _step_start
    xchg esi, edi

_step_start:
    mov al, [esi + edx]
    cmp al, '.'
    je _step_next

    push ebx, ecx
    xor ah, ah

    mov ebx, area.width + 1
    call _step_count_vacant
    mov ebx, area.width
    call _step_count_vacant
    mov ebx, area.width - 1
    call _step_count_vacant
    mov ebx, 1
    call _step_count_vacant
    mov ebx, -1
    call _step_count_vacant
    mov ebx, -area.width-1
    call _step_count_vacant
    mov ebx, -area.width
    call _step_count_vacant
    mov ebx, -area.width+1
    call _step_count_vacant
    pop ebx, ecx

    cmp al, 'L'
    jne _step_seat_occupied
    cmp ah, 8
    jne _step_update
    mov al, '#'
    inc dword [ebp]
    jmp _step_update

_step_seat_occupied:
    cmp ah, 5
    jge _step_update
    inc dword [ebp]
    mov al, 'L'

_step_update:
    mov [edi + edx], al

_step_next:
    dec edx
    dec ecx
    jnz _step_start

    mov ecx, area.width - 2
    sub edx, 2
    dec ebx
    jnz _step_start

    call switch_phase
    mov eax, [ebp]
    add esp, 4
    pop ebp
    ret

_step_count_vacant:
    add ebx, edx
    mov cl, [esi + ebx]
    cmp cl, '#'
    je _step_count_vacant_exit
    inc ah
_step_count_vacant_exit:
    ret


_start:
    mov [area.phase], byte 0
    call read_input

converge_loop:
    call one_step
    test eax, eax
    jnz converge_loop

    call count_occupied
    test eax, eax
    jz exit
    call print_decimal

exit:
    mov eax, 1
    xor ebx, ebx
    int 80h
