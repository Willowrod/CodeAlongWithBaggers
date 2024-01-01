
menu:    
    ld e, %11100000
    call clear_layer_2_with_e
    call sprint_layer_2
    db PRINTAT,64,32,"WILLOW ROD GAMES"
    db PRINTAT,96,48,"PRESENTS"
    db PRINTINK, 2*8+7+64
    db PRINTAT,80,80,"LIGHT RIDING"
    db PRINTINK, 56
    db PRINTAT,48,144,"PRESS SPACE TO PLAY"
    db PRINTAT,48,152,"PRESS ZERO TO EXIT!"
    db PRINTEOF
    ret


registers:
    ld (debug_data_1), a
    call sprint_layer_2
    db PRINTAT,104,2,PRINTINK, 56,"A: ", PRINTHEX16 ;PRINTINK, 2*8+7,
    dw debug_data_1
    db PRINTEOF
    ret