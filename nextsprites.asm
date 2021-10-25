spr_off:
    NEXTREG SPR_SELECT, 0
    ld b, 128
s_offlp:
    NEXTREG SPR_PATTERN_INC, 0 ; Clear all 128 possible sprtites
    DJNZ s_offlp
    ret

addsprite:
    ret
    ld a,e
    nextreg SPR_X_VALUE,a
    ld a,l
    nextreg SPR_Y_VALUE,a
    ld a,d
    and 1
    or b
    nextreg SPR_X_MSB_FLIP,a
    ld a,c
    or $c0
    nextreg SPR_PATTERN, a
    ld a,h
    nextreg SPR_ATTRIBUTES_INC, a
    ret
DMASprites:
    ld (DMAsrcS),HL
    ld (DMAlenS), BC
    ld bc, $303b
    out (c), a
    ld hl, DMAcodeS
    ld b, DMAcodelenS
    ld c, Z80_DMA_DATAGEAR_PORT
    otir
    ret

DMAcodeS:
    DB DMA_DISABLE
    DB %01111101
DMAsrcS:
    DW 0
DMAlenS:
    DW 0
    DB %01010100
    DB %00000010
    DB %01101000
    DB %00000010
    DB %10101101
    DW SPR_IMAGE_PORT
    DB %10000010
    DB DMA_LOAD
    DB DMA_ENABLE
DMAcodelenS    EQU $-DMAcodeS