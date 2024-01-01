

initial_player_x:
    db 128
initial_player_y:
    db 96
xpos: 
    db 128
ypos: 
    db 96
player_lives:
    db START_LIVES

player_direction:
    db 0

score:
    db 12
bigscore:
    dw $ff00

sprites incbin "arrow.spr"

font incbin "SpecFont.chr"

initial_character_data:
    db 4
    dw char_1_action_table
    db $16,$20
    db 0
    db 0
    db 0
    db 0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0

    db 2
    dw char_1_action_table
    db $a0,$20
    db 0
    db 0
    db 0
    db 0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0

character_data
    ds TOTAL_CHARACTERS*CHARACTER_SIZE

char_1_action_table:
    dw char1_stand_still
    dw char1_down
    dw char1_left
    dw char1_up
    dw char1_right


gameover:
    db 0
player_dead:
    db 0

debug_data_1:
    dw 0
debug_data_2:
    dw 0
debug_data_3:
    dw 0

stackstore:
    dw 0

storedbanks:
    db 0,0,0,0,0,0,0,0
currentbanks:
    db 0,0,0,0,0,0,0,0