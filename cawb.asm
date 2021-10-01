                OPT     --zxnext    
                DEVICE  ZXSPECTRUMNEXT                               // tell the assembler we want it for Spectrum Next
                ORG     0x8000
StackEnd:
                ds      127 
StackStart:     db      0        
//              org StackStart
StartAddress   
    LD A,0
    LD (xpos), A
    LD (ypos), A

loop:
    CALL delay
    LD A, (xpos)
    LD E,A
    LD A, (ypos)
    LD D,A
    CALL plot
    LD BC, $fbfe
    IN A, (C)
    BIT 0, A
    JR NZ, notq
    DEC D
notq:
    LD BC, $fdfe
    IN A, (C)
    BIT 0, A
    JR NZ, nota
    INC D
nota:
    LD BC, $dffe
    IN A, (C)
    BIT 1, A
    JR NZ, noto
    DEC E
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
    LD BC, $7ffe
    IN A, (C)
    BIT 0, A
    RET Z
    JP loop
plot:
    LD A,D
    CP 192
    RET NC
    PIXELAD
    SETAE
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
xpos: 
    NOP
ypos: 
    NOP

//end start 
// now we save the compiled file so we can either run it or debug it
                SAVENEX OPEN "cawb.nex", StartAddress
                SAVENEX CORE 3, 0, 0                                // Next core 3.0.0 required as minimum
                SAVENEX CFG  0
                SAVENEX AUTO
                SAVENEX CLOSE    