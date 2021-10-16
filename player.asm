



set_lives:
    XOR a
    ld (gameover), a
    ld a,START_LIVES
    ld (player_lives), a

init_player:
    ld de, $b080
    ld (xpos), de
    ld a, PLAYER_MOVE_UP
    ld (player_direction), a
    xor a
    ld (player_dead), a
    ret

draw_player:
    ld a,(xpos)
    ld e,a
    ld d,0
    add de,32
    ld a,(ypos)
    add a,32
    ld l,a
    ld c,$00 ;7 - visible : 6 - enable attrib 4 : 5-0 - image number
    ld b,$00 ;7-4 - colour offset : 3 - xflip : 2 - yflip : 1 - rotate : 0 - x8 msb x
    ld h,$00 ;7 - 4bit : 6 - image lsb : 6 - t relative : 4-3 - xscale : 21 - yscale : 0 - y8 msb y
    call addsprite
    ret
handle_player:
    ld a,(player_direction)
    ld l,a

; Check for Q being pressed
    LD BC, $fbfe
    IN A, (C)
    BIT 0, A
    JR NZ, notq
    ld l,PLAYER_MOVE_UP
; Check for A being pressednotq:
notq:
    LD BC, $fdfe
    IN A, (C)
    BIT 0, A
    JR NZ, nota
    ld l,PLAYER_MOVE_DOWN
; Check for O being pressed
nota:
    LD BC, $dffe
    IN A, (C)
    BIT 1, A
    JR NZ, noto
    ld l,PLAYER_MOVE_LEFT
; Check for P being pressed
noto:
    LD BC, $dffe
    IN A, (c)
    BIT 0, A
    JR NZ, notp
    ld l,PLAYER_MOVE_RIGHT

notp:
    ld a,l
    ld (player_direction), a
    and 3
    ld hl, URDLjptable
    call usejumptable
    call checkpixel
    jp nz, player_death
    LD A,E
    LD (xpos), A
    LD A,D
    LD (ypos), A
    call plot
    ret

URDLjptable:
    dw player_up
    dw player_right
    dw player_down
    dw player_left

player_up:
    dec d
    ret

player_right:
    inc e
    ret

player_down:
    inc d
    ret

player_left:
    dec e
    ret

player_death:
    ld a,1
    ld (player_dead), a
    ld a, (player_lives)
    dec a
    ld (player_lives), a
    ret nz
    ld a,1
    ld (gameover), a
    ret


check_m
    ; Check for M being pressed
    LD BC, $7FFE
    IN A, (C)
    BIT 2,A
    CALL Z, plot
    ret
