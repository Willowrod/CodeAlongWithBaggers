            include"defines.asm"
            
                OPT     --zxnext    
                DEVICE  ZXSPECTRUMNEXT                               // tell the assembler we want it for Spectrum Next
                ORG     0x8000

StackEnd:
                ds      127 
StackStart:     db      0        
//              org StackStart
StartAddress   
    NEXTREG CPU_SPEED, SPEED_3_5_MHZ
    LD A,0
    LD (xpos), A
    LD (ypos), A

    LD HL,sprites
    ld bc, $4000
    ld a,0
    call DMASprites

    NEXTREG SPR_LAYER_CONTROL, $01


loop:
    NEXTREG SPR_SELECT, 1
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

    CALL delay
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

spr_off:
    NEXTREG SPR_SELECT, 0
    ld b, 128
s_offlp:
    NEXTREG SPR_PATTERN_INC, 0 ; Clear all 128 possible sprtites
    DJNZ s_offlp
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
    LD HL, 3000
dellp:
    DEC HL
    LD A,H
    OR L
    JR NZ,dellp
    RET

addsprite:
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
    ld (DMAlenS),BC
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


xpos: 
    NOP
ypos: 
    NOP

sprites incbin "arrow.spr"

//end start 
// now we save the compiled file so we can either run it or debug it
                SAVENEX OPEN "cawb.nex", StartAddress
                SAVENEX CORE 3, 0, 0                                // Next core 3.0.0 required as minimum
                SAVENEX CFG  0
                SAVENEX AUTO
                SAVENEX CLOSE    