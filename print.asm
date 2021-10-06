sprint:
    pop hl
    call print
    jp (hl)



    ;print_routines
    ; DE = position, HL = message, A = character

print:
    ld a,(hl)
    inc hl
    cp PRINTEOF
    ret z
    cp 32
    jr c, printcode
    call printchar
    jp print

printcode:
    cp PRINTAT
    jr nz,notprintat
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    jp print

notprintat:
    cp PRINTINK
    jp nz, notprintink
    ld a, (hl)
    inc hl
    ld (attr), a
    jp print
notprintink:
    cp PRINTCLS
    jp nz, notprintcls
    push hl
    ld hl, $4000
    ld de, $4001
    ld bc, $1800
    ld (hl), l
    ldir
    ld bc, $2ff
    ld a, (attr)
    ld (hl), a
    ldir
    pop HL
    ld DE,0
    jp print
notprintcls:
    jp print

printchar:
    push HL
    push DE
    pixelad
    ex de,hl
    sub 32
    ld L, A
    ld h, 0
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,font
    ex de,hl
    ld b,8
printcharloop:
    ld a,(de)
    ld (hl),a
    pixeldn         ;moves HL down 1 pixel
    inc de
    djnz printcharloop

    ld a,h
    and %011000
    rra
    rra
    rra
    or $58
    ld h,a
    ld a,(attr)
    ld (hl),a

    pop de
    pop hl
    ld a,e
    add a,8
    ld e,a
    ret nc
    ld e,0
    ld a,d
    add a,8
    ld d,a
    ret

attr: db 2