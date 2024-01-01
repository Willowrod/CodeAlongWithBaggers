
getbanks:
    ld hl, storedbanks
    ld ix, currentbanks
    ld de, 8*256+MMU_REGISTER_0
getbanks_loop:
    ld bc, NEXTREG_REG_SELECT_PORT
    ld a,e
    out (c), a
    inc b
    in a, (c)
    ld (hl), a
    inc hl
    ld (ix+0), a
    inc ix
    inc e
    dec d
    jr nz, getbanks_loop
    ret

setbanks:
    ld hl, storedbanks
setbanks_hl:
    ld ix, currentbanks
    ld de, 8*256+MMU_REGISTER_0
setbanks_loop:
    ld bc, NEXTREG_REG_SELECT_PORT
    ld a,e
    out (c), a
    inc b
    ld a, (hl)
    inc hl
    ld (ix+0), a
    inc ix
    out (c), a
    inc e
    dec d
    jr nz, setbanks_loop
    ret
    

setbankc000:
    add a,a
    ld (currentbanks+6), a
    nextreg MMU_REGISTER_6, a
    inc a
    ld (currentbanks+7), a
    nextreg MMU_REGISTER_7, a
    ret

setbanksc000:
    ld a,l
    ld (currentbanks+6), a
    nextreg MMU_REGISTER_6, a
    ld a,h
    ld (currentbanks+7), a
    nextreg MMU_REGISTER_7, a
    ret

clearbank:
    push af
    push hl
    push de
    push bc
    ld hl, (currentbanks+6)
    push hl
    call setbankc000
    ld hl, $c000
    ld (HL), e
    ld de, $c001
    ld bc, $3fff
    ldir
    pop hl
    call setbanksc000
    pop bc
    pop de
    pop hl
    pop af
    ret