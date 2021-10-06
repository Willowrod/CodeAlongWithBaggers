
            
                OPT     --zxnext    
                DEVICE  ZXSPECTRUMNEXT                               // tell the assembler we want it for Spectrum Next
                ORG     0x8000
            include"defines.asm"
            include"gamedefines.asm"
            include"nextsprites.asm"
            include"print.asm"
            include"commonroutines.asm"
            include"gamedata.asm"
StackEnd:
                ds      127 
StackStart:     db      0        
StartAddress   
    NEXTREG CPU_SPEED, SPEED_3_5_MHZ
    LD A,$55
    ld ($4000), A
    LD HL,sprites
    ld bc, $4000
    ld a,0
    call DMASprites

    NEXTREG SPR_LAYER_CONTROL, $01

    call sprint
    db PRINTINK,56,PRINTCLS
    db PRINTAT,32,0,"Score: ",PRINTINK, 2*8+7, PRINTDECIMAL8
    dw score
    db PRINTAT,0,8,PRINTINK, 56,"Big score: ",PRINTINK, 2*8+7, PRINTDECIMAL16
    dw bigscore
    db PRINTEOF

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


//end start 
// now we save the compiled file so we can either run it or debug it
                SAVENEX OPEN "cawb.nex", StartAddress
                SAVENEX CORE 3, 0, 0                                // Next core 3.0.0 required as minimum
                SAVENEX CFG  0
                SAVENEX AUTO
                SAVENEX CLOSE    