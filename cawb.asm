
            
                OPT     --zxnext    
                DEVICE  ZXSPECTRUMNEXT                               // tell the assembler we want it for Spectrum Next
                ORG     0x8000
            include"defines.asm"
            include"gamedefines.asm"
            include"nextsprites.asm"
            include"print.asm"
            include"commonroutines.asm"
            include"gamedata.asm"
            include"player.asm"
            include"game.asm"
            include"enemies.asm"
StackEnd:
                ds      127 
StackStart:     db      0        
StartAddress   
    NEXTREG CPU_SPEED, SPEED_28_MHZ
    LD A,$55
    ld ($4000), A
    LD HL,sprites
    ld bc, $4000
    ld a,0
    call DMASprites

    NEXTREG SPR_LAYER_CONTROL, $01

    call sprint
    db PRINTINK,56,PRINTCLS
    ; db PRINTAT,32,0,"Score: ",PRINTINK, 2*8+7, PRINTDECIMAL8
    ; dw score
    ; db PRINTAT,0,8,PRINTINK, 56,"Big score: ",PRINTINK, 2*8+7, PRINTDECIMAL16
    ; dw bigscore
    db PRINTEOF

    call draw_boundries

    call init_player
    call init_npcs

loop:
    NEXTREG SPR_SELECT, 1


    call draw_player
    call draw_characters
    call handle_characters
    CALL delay
    call handle_player



//end start 
// now we save the compiled file so we can either run it or debug it
                SAVENEX OPEN "cawb.nex", StartAddress
                SAVENEX CORE 3, 0, 0                                // Next core 3.0.0 required as minimum
                SAVENEX CFG  0
                SAVENEX AUTO
                SAVENEX CLOSE    