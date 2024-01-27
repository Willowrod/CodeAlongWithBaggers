
            
                OPT     --zxnext    
                DEVICE  ZXSPECTRUMNEXT                               // tell the assembler we want it for Spectrum Next
                ORG     0x6000
    
StartAddress: 
    ld (stackstore), sp
    ld sp,stack_start

    nextreg CPU_SPEED, SPEED_28_MHZ

     call enter_layer_2
     call getbanks

    ld HL,sprites
    ld bc, $4000
    ld a,0
    call DMASprites

    nextreg SPR_LAYER_CONTROL, $01

        ld  bc, $243b     // tbblue port again
    ld  a, $4b      // choose the transparency index register for sprites
    out  (c), a  
    ld  bc, $253b     // tell it the index
    ld  a, 0      // setting the transparency index to palette element 0
    out  (c), a      // yup send it 

new_game:
    call set_lives


respawn:
 ;   call clear_layer_2
    call init_player
    call init_npcs

    call spr_off
    ld de, 0
    ld a, 0
    call draw_room_layer_2

    call menu
check_for_input:
    call wait_for_space_loop    
    jp z, start_game
check_for_quit:
    call wait_for_zero_loop
    jp z, exit_program
    jp check_for_input
start_game:
 ;   call menu
 ;   call clear_layer_2

 ;   call draw_boundries
    call draw_room_layer_2
loop:
 ;   call print_out_data
 ;   call draw_room_layer_2
    
 ;   call draw_sprites_on_screen
    
    call handle_player
    call handle_characters


    call delay
    ; check for space to quit.....
    ld BC, $7ffe
    in A, (C)
    bit 0, A
    jp nz, normal_loop_continue
    call wait_for_space_release_loop
    jp respawn

normal_loop_continue:
    call check_game_status

    call debug_1_inc

    jp loop

draw_sprites_on_screen:
    ;nextreg SPR_SELECT, 1


    call draw_player
    call draw_characters
    ret
game_exit:
    call spr_off
    ret

exit_program:

    call setbanks
    call exit_layer_2
    ld sp, (stackstore)
    ld a,5
    call change_border_to_a
    ret


            include"banks.asm"
            include"defines.asm"
            include"gamedefines.asm"
            include"nextsprites.asm"
            include"print.asm"
            include"commonroutines.asm"
            include"gamedata.asm"
            include"player.asm"
            include"game.asm"
            include"enemies.asm"
            include"menu.asm"
            include"screentasks.asm"
            include"graphics.asm"

//end start 
// now we save the compiled file so we can either run it or debug it
  //              SAVENEX OPEN "cawb.nex", StartAddress
                SAVENEX OPEN "/Users/mikehall/Documents/NextSync/home/CAWB/cawb.nex", StartAddress
                SAVENEX CORE 3, 0, 0                                // Next core 3.0.0 required as minimum
                SAVENEX CFG  0
                SAVENEX AUTO
                SAVENEX CLOSE    


    DISPLAY $
    ASSERT $<$C000