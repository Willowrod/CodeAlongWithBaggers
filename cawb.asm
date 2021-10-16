
            
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
    ld a, 56
    call setink
    call cls

    call draw_boundries
new_game:
    call set_lives


respawn:
    call init_player
    call init_npcs

loop:
    call print_out_data
    
    NEXTREG SPR_SELECT, 1


    call draw_player
    call draw_characters
    
    call handle_player
    call handle_characters


    CALL delay
    
    LD BC, $7ffe
    IN A, (C)
    BIT 0, A
    jp z, game_exit
    call check_game_status

    call debug_1_inc

    jp loop

game_exit:
    call spr_off
    ret


//end start 
// now we save the compiled file so we can either run it or debug it
                SAVENEX OPEN "cawb.nex", StartAddress
                SAVENEX CORE 3, 0, 0                                // Next core 3.0.0 required as minimum
                SAVENEX CFG  0
                SAVENEX AUTO
                SAVENEX CLOSE    