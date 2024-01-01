sprint_layer_2:
    pop hl
    call print_layer_2
    jp (hl)

print_layer_2:
    ld a,(hl)
    inc hl
    cp PRINTEOF
    ret z
    cp 32
    jr c, printcode_layer_2
    call printchar_layer_2
    jp print_layer_2



printcode_layer_2:
    cp PRINTAT
    jr nz,notprintat_layer_2
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    jp print_layer_2


notprintat_layer_2:
    cp PRINTINK
    jp nz, notprintink_layer_2
    ld a, (hl)
    inc hl
    ld (pchrink_layer_2+1), a
    jp print_layer_2


notprintink_layer_2:
    cp PRINTCLS
    jp nz, notprintcls_layer_2
    call cls_layer_2
    ld DE,0
    jp print_layer_2

notprintcls_layer_2:
    cp PRINTDECIMAL8
    jr nz, notprintdec8_layer_2
    ld c, (hl)
    inc hl
    ld b,(hl)
    inc hl
    push hl
    ld a, (bc)
    ld l,a
    ld h, 0
    call printdec100_layer_2
    pop hl
    jp print_layer_2

notprintdec8_layer_2:
    cp PRINTDECIMAL16
    jp nz, notprintdec16_layer_2
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
    call printdec10000_layer_2
    pop hl
    jp print_layer_2


notprintdec16_layer_2:
    cp PRINTHEX8
    jp nz, notprinthex8_layer_2
    ld c, (hl)
    inc hl
    ld b,(hl)
    inc hl
    push hl
    ld a, (bc)
    ld l,a
    ld h, 0
    call printhex8_layer_2
    pop hl
    jp print_layer_2
notprinthex8_layer_2:
    cp PRINTHEX16
    jp nz, notprinthxe16_layer_2
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
    call printhex16_layer_2
    pop hl
    jp print_layer_2
notprinthxe16_layer_2:
    jp print_layer_2

printchar_layer_2:
    push hl
    push de
    push bc
    ld c,a
    ld hl, (currentbanks+6)
    push hl
    ld a,d
    and %11100000
    rlca
    rlca
    rlca
    add 9*2
    ld (currentbanks+6), a
    nextreg MMU_REGISTER_6, a
    inc a
    ld (currentbanks+7), a
    nextreg MMU_REGISTER_7, a
    ld a,d
    and %00011111
    or $c0
    ld d,a
    ld a,c
    sub 32

    ld l,a
    ld h,0
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,font

    ex de,hl

    ld c,8
pchrclp_layer_2:
    ld b,8
    ld a,(de)
    inc de
pchrblp_layer_2:
    rla
    jr nc, pchrpap_layer_2

pchrink_layer_2:
    ld (hl), 255
    jr pchrdone_layer_2

pchrpap_layer_2:
    ld (hl), 0

pchrdone_layer_2:
    inc l
    djnz pchrblp_layer_2
    ld a,l
    sub 8
    ld l,a
    inc h
    dec c
    jr nz, pchrclp_layer_2
    pop hl
    call setbanksc000


    pop bc
    pop de
    pop hl

    ld a,e
    add a,8
    ld e,a

    ret nc
    ld a,d
    add a,8
    ld d,a
    cp 192
    ret c
    ld d,0
    ret


printdec10000_layer_2:
    ld  bc, 10000
    call printdec1_layer_2
printdec1000_layer_2:
    ld  bc, 1000
    call printdec1_layer_2
printdec100_layer_2:
    ld  bc, 100
    call printdec1_layer_2
printdec10_layer_2:
    ld  bc, 10
    call printdec1_layer_2
    ld a,l
    jr printdec0_layer_2
printdec1_layer_2:
    ld a,255
printdecl_layer_2:
    inc a
    or a
    sbc hl,bc
    jr nc, printdecl_layer_2
    add hl, bc
printdec0_layer_2:
    add a, "0"
    call printchar_layer_2
    ret

cls_layer_2:
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

printhex16_layer_2:
    ld a,h
    call printhex8_layer_2
    ld a,l
printhex8_layer_2:
    push af
    swapnib
    call printhex4_layer_2
    pop af
printhex4_layer_2:
    and 15
    push hl
    ld hl,hextab
    add hl,a
    ld a,(hl)
    call printchar_layer_2
    pop hl
    ret


hextab:
    db "0123456789ABCDEF"


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
    cp PRINTHEX8
    jp nz, notprinthex8
    ld c, (hl)
    inc hl
    ld b,(hl)
    inc hl
    push hl
    ld a, (bc)
    ld l,a
    ld h, 0
    call printhex8
    pop hl
    jp print
notprinthex8:
    cp PRINTHEX16
    jp nz, notprinthxe16
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
    call printhex16
    pop hl
    jp print
notprinthxe16:
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

printhex16:
    ld a,h
    call printhex8
    ld a,l
printhex8:
    push af
    swapnib
    call printhex4
    pop af
printhex4:
    and 15
    push hl
    ld hl,hextab
    add hl,a
    ld a,(hl)
    call printchar
    pop hl
    ret







attr: db 2
l2ink: db 2