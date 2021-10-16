
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
    LD HL, 3000
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
