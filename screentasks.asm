enter_layer_2:
    ld bc, LAYER_2_ACCESS_PORT
    ld a,2
    out (c),a
    ret

exit_layer_2:
    ld bc, LAYER_2_ACCESS_PORT
    xor a
    out (c),a
    ret

clear_layer_2:
    ld e,0
clear_layer_2_with_e:
    ld a,9
    call clearbank
    ld a,10
    call clearbank
    ld a,11
    jp clearbank ;will return from clearbank

plot_layer2:
    push HL
    push DE
    push BC
    push af
    ;ld a,255
    ld c,a
    ld hl, (currentbanks+6)
    push af
    ld a,d
    and %11100000
    rlca
    rlca
    rlca
    add a, 9*2
    ld (currentbanks+6), a
    nextreg MMU_REGISTER_6, a
    ld a, d

    and %00011111
    or $c0
    ld d,a
    ld a,c
    ld (de), a
    pop af
    ld (currentbanks+6), a
    nextreg MMU_REGISTER_6, a
    pop af
    pop bc
    pop de
    pop hl
    ret



checkpixel_layer2:
    push HL
    push DE
    push BC
    ld (currentbanks+6), a
    nextreg MMU_REGISTER_6, a
    push af

    ld a,d
    and %11100000
    rlca
    rlca
    rlca
    add a, 9*2
    ld (currentbanks+6), a
    nextreg MMU_REGISTER_6, a
    ld a, d

    and %00011111
    or $c0
    ld d,a

    ld a, (de)
    ld c,a



    pop af
    ld (currentbanks+6), a
    nextreg MMU_REGISTER_6, a
    ld a,c
    pop bc
    pop de
    pop hl
    or a
    ret