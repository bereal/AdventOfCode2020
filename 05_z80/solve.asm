putchar:    equ $8000
getchar:    equ $8003
CR:         equ $a

main:
    call read_input

    call find_max
    call putdec
    ld a, ' '
    call putchar

    call find_mine
    call putdec
    ld a, CR
    call putchar

    halt


;; Read all tickets
;; set tickets[i] to 1 when the seat i is taken
read_input:
    ld de, tickets

    call read_ticket
    ret c

    add hl, de
    inc (hl)

    jr read_input


;; Read seat number as a bitmask to HL
;; Set C flag at the end of input
read_ticket:
    ld hl, 0
    ld b, 10

_read_loop:
    call getchar
    ret c

    cp CR
    jr z, _read_loop

    ;; in B and R bit 2 is 0, in F and L it's 1
    ;; a <- !a_2
    sra a
    sra a
    and 1
    xor 1

    ;; hl <- (hl << 1) + a
    add hl, hl
    add l
    ld l, a

    djnz _read_loop
    ret


;; Find max occupied seat, return in HL
find_max:
    ld de, $400
    ld hl, tickets
    add hl, de

_find_max_loop:
    dec hl
    dec de
    ld a, (hl)
    and a
    jr z, _find_max_loop

    push de
    pop hl
    ret


;; Find mine seat, return in HL
find_mine:
    xor a      ;; last 3 seats status in the lowest bits
    ld de, -1  ;; previous set number
    ld hl, tickets

_find_mine_loop:
    inc hl
    inc de
    sla a
    add a, (hl)
    and 7
    cp 5  ;; 101b, previous seat is mine
    jr nz, _find_mine_loop

    push de
    pop hl
    ret


;; Print decimal from HL
;; (from http://map.grauw.nl/sources/external/z80bits.html#5.1)
putdec:
    ld e, 0
    ld bc, -10000
    call _putdec1
    ld bc, -1000
    call _putdec1
    ld bc, -100
    call _putdec1
    ld c, -10
    call _putdec1
    ld c, b

_putdec1:
    ld a, $ff

_putdec2:
    inc a
    add hl, bc
    jr c, _putdec2
    sbc hl, bc

    and a
    jr nz, _putdec3

    or e
    ret z  ;; suppress leading zeros
    xor a

_putdec3:
    ld e, 1
    add '0'
    call putchar
    ret

;; here be data
tickets: