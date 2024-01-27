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
    ;or a
    cp a, $e3
    ret

draw_room_layer_2:
 ;   call push_all

    ld e, 12*16
    ld d,a
    mul d,e
    ld hl, roomdata
    add hl, de
    ld de,0
    ;ld c, 12

draw_room_layer_2_c_loop:
    ld b, 16

draw_room_layer_2_b_loop:
    ld a, (hl)
    inc hl
    call draw_sprite_layer_2
    ld a, e
    add a, 16
    ld e, a
    djnz draw_room_layer_2_b_loop

    ld a, d
    add a, 16
    ld d, a
    cp 192

    jp c, draw_room_layer_2_c_loop

 ;   call pop_all
    ret

draw_sprite_layer_2:
;    call push_all

    PUSH HL
    PUSH DE
    PUSH BC
    PUSH AF
    ld l, 0
    ld h, a
    add hl, sprites
    ld a, (currentbanks + 1)
    push af
    ld a,d
    and $e0
    rlca
    rlca
    rlca
    add a, 9*2
    ld (currentbanks + 1), a
    nextreg MMU_REGISTER_1, a
    ld a, d
    and $1f
    add a, $20 ; point to 8k bank 1
    ld d, a
    ld c, 16
draw_l2_sprite_c_lp:
    ld b, 16
draw_l2_sprite_b_lp:
    ld a, (hl)
    ld (de), a
    inc hl
    inc e
    djnz draw_l2_sprite_b_lp
    ld a,e
    sub 16
    ld e, a
    inc d
    dec c
    jp nz, draw_l2_sprite_c_lp
    pop af
    ld (currentbanks + 1), a
    nextreg MMU_REGISTER_1, a
    ;call pop_all
    pop AF
    pop BC
    pop DE
    pop HL
    ret



