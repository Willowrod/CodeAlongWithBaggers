

xpos: 
    db 128
ypos: 
    db 96

score:
    db 12
bigscore:
    dw $ff00

sprites incbin "arrow.spr"

font incbin "SpecFont.chr"

numberofcharacters:
    db 2
characterdata:
    db 1
    dw char_1_action_table
    db $60,$08
    db 0
    db 0
    db 0
    db 0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0

    db 2
    dw char_1_action_table
    db $a0,$08
    db 0
    db 0
    db 0
    db 0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0

char_1_action_table:
    dw char1_stand_still
    dw char1_down
    dw char1_left
    dw char1_up
    dw char1_right


