debug:
    push de
    ld de, (debug_data_1)
    call printhex8
    ld (debug_data_1), de
    pop de

    ret

debug_1_inc:
    push hl
    ld hl, (debug_data_1)
    inc hl
    ld (debug_data_1), hl
    pop hl
    ret

plot:
    LD A,D
    CP 192
    RET NC
    PIXELAD ; Sets HL to the pixel address of de
    SETAE ; Sets a - 'The corrct bit set for E pixel X coord & 7' ???
    OR(HL)
    LD(HL), A
    RET
delay: 
    LD HL, 10000
dellp:
    DEC HL
    LD A,H
    OR L
    JR NZ,dellp
    RET

usejumptable:
    add hl, a
    add hl, a
    ld a, (hl)
    inc hl
    ld h, (hl)
    ld l,a
    jp (hl)

l2plot:
