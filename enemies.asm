
char1_stand_still:
    ret
char1_down:
    ld a,d
    cp 191
    jr z, bad1_md_wall
    inc d
    ld (ix+CHARACTER_Y), d
    ret
char1_left:
    ld a,e
    or a
    jr z, bad1_md_wall
    dec e
    ld (IX+CHARACTER_X), e
    ret
char1_up:
    ld a,d
    or a
    jr z, bad1_md_wall
    dec d
    ld (IX+CHARACTER_Y), d
    ret
char1_right:
    ld a,e
    cp 255
    jr z, bad1_md_wall
    inc e
    ld (IX+CHARACTER_X), e
    ret

bad1_md_wall:
    ld a,(ix+CHARACTER_ACTION)
    and 3
    inc a
    ld (ix+CHARACTER_ACTION), a
    ret
