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
    call setink
    jp print
notprintink:
    cp PRINTCLS
    jp nz, notprintcls
    call cls
    ld DE,0
    jp print
notprintcls:
    cp PRINTDECIMAL8
    jr nz, notprintdec8
    ld c, (hl)
    inc hl
    ld b,(hl)
    inc hl
    push hl
    ld a, (bc)
    ld l,a
    ld h, 0
    call printdec100
    pop hl
    jp print

notprintdec8:
    cp PRINTDECIMAL16
    jp nz, notprintdec16
    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    push hl
    ld a, (bc)
    ld l,a
    inc bc
    ld a,(bc)
    ld h,a
    call printdec10000
    pop hl
    jp print


notprintdec16:
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
    add hl, -32
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

printdec10000:
    ld  bc, 10000
    call printdec1
printdec1000:
    ld  bc, 1000
    call printdec1
printdec100:
    ld  bc, 100
    call printdec1
printdec10:
    ld  bc, 10
    call printdec1
    ld a,l
    jr printdec0
printdec1:
    ld a,255
printdecl:
    inc a
    or a
    sbc hl,bc
    jr nc, printdecl
    add hl, bc
printdec0:
    add a, "0"
    call printchar
    ret

cls:
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
    ret

setink:    ; Sets the ink and paper to the current value of 'a'
    ld (attr), a
    ret

attr: db 2