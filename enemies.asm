
init_npcs:
    ld hl, initial_character_data
    ld de, character_data
    ld bc, TOTAL_CHARACTERS*CHARACTER_SIZE
    ldir
    ret

draw_characters:
    ld ix, character_data
    ld b,TOTAL_CHARACTERS
drawcharactersloop:
    push bc

    ld e, (ix+CHARACTER_X)
    ld d,0
    add de, 32
    ld a, (ix+CHARACTER_Y)
    add a, 32
    ld l,a
    ld c,0
    ld b,0
    ld h,0
    call addsprite

    pop bc
    ld de, CHARACTER_SIZE
    add ix, de
    djnz drawcharactersloop
    ret


handle_characters:
    ld ix, character_data
    ld a,TOTAL_CHARACTERS
    ld b,a
handle_character_loop:
    push bc
    ld e,(IX+CHARACTER_X)
    ld d,(ix+CHARACTER_Y)

    ld a, (IX+CHARACTER_ACTION)
    ld l, (IX+CHARACTER_ACTION_TABLE)
    ld h, (IX+CHARACTER_ACTION_TABLE+1)
    call usejumptable

    ld e,(IX+CHARACTER_X)
    ld d,(ix+CHARACTER_Y)
    call plot


    pop bc
    ld de, CHARACTER_SIZE
    add ix, de
    djnz handle_character_loop
    ret

usejumptable:
    add hl, a
    add hl, a
    ld a, (hl)
    inc hl
    ld h, (hl)
    ld l,a
    jp (hl)
char1_stand_still:
    ret
char1_down:
    inc d
    call checkpixel
    jr nz, tryleftorright
    ld (ix+CHARACTER_Y), d
    ret
char1_left:
    dec e
    call checkpixel
    jr nz, tryupordown
    ld (IX+CHARACTER_X), e
    ret
char1_up:
    dec d
    call checkpixel
    jr nz, tryleftorright
    ld (IX+CHARACTER_Y), d
    ret
char1_right:
    inc e
    call checkpixel
    jr nz, tryupordown
    ld (IX+CHARACTER_X), e
    ret

hitwall:
    ld a,(ix+CHARACTER_ACTION)
    and 3
    inc a
    ld (ix+CHARACTER_ACTION), a
    ret


checkpixel:
    pixelad
    setae
    and (HL)
    ret

tryleftorright:
    ld d,(IX+CHARACTER_Y)
    ld a,r
    and 4
    jr z, tryleft
tryright:
    inc e
    ld (IX+CHARACTER_X), E
    ld (IX+CHARACTER_ACTION), MOVE_RIGHT
    call checkpixel
    ret z
    dec e
    dec e
    ld (IX+CHARACTER_X), E
    ld (IX+CHARACTER_ACTION), MOVE_UP
    call checkpixel
    ret z
    jp setdead

tryleft:
    dec e
    ld (IX+CHARACTER_X), e
    ld (IX+CHARACTER_ACTION), MOVE_LEFT
    call checkpixel
    ret z
    inc e
    inc e
    ld (IX+CHARACTER_X), E
    ld (IX+CHARACTER_ACTION), MOVE_RIGHT
    call checkpixel
    ret z
    jp setdead

tryupordown:
    ld e,(IX+CHARACTER_X)
    ld a,r
    and 4
    jr z, tryup
trydown:
    inc d
    ld (IX+CHARACTER_Y), d
    ld (IX+CHARACTER_ACTION), MOVE_DOWN
    call checkpixel
    ret z
    dec d
    dec d
    ld (IX+CHARACTER_Y), d
    ld (IX+CHARACTER_ACTION), MOVE_UP
    call checkpixel
    ret z
    jp setdead
tryup:
    dec d
    ld (IX+CHARACTER_Y), d
    ld (IX+CHARACTER_ACTION), MOVE_UP
    call checkpixel
    ret z
    inc d
    inc d
    ld (IX+CHARACTER_Y), d
    ld (IX+CHARACTER_ACTION), MOVE_DOWN
    call checkpixel
    ret z
    jp setdead
setdead:
    ld (IX+CHARACTER_ACTION), STOP_CHARACTER
    ret



