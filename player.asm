


init_player:
    ld de, $b080
    ld (xpos), de
    xor a
    ld (player_direction), a
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
    ld c,a

    LD A, (xpos)
    LD E,A
    LD A, (ypos)
    LD D,A
; Check for M being pressed
    LD BC, $7FFE
    IN A, (C)
    BIT 2,A
    CALL Z, plot

; Check for Q being pressed
    LD BC, $fbfe
    IN A, (C)
    BIT 0, A
    JR NZ, notq
    DEC D
; Check for A being pressednotq:
notq:
    LD BC, $fdfe
    IN A, (C)
    BIT 0, A
    JR NZ, nota
    INC D
; Check for O being pressed
nota:
    LD BC, $dffe
    IN A, (C)
    BIT 1, A
    JR NZ, noto
    DEC E
; Check for P being pressed
noto:
    LD BC, $dffe
    IN A, (c)
    BIT 0, A
    JR NZ, notp
    INC E
notp:
    LD A,E
    LD (xpos), A
    LD A,D
    LD (ypos), A

; Check for Space being pressed - exit
    LD BC, $7ffe
    IN A, (C)
    BIT 0, A
    jp NZ, loop
    call spr_off
    ret