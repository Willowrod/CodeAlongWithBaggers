draw_boundries:   
    ld e,0
boxloop:
    ld d,10
    call plot
    ld d,181
    call plot
    ld d,e
    ld e,10
    call plot
    ld e,245
    call plot
    ld e,d
    inc e
    jr nz, boxloop
    ret


print_out_data:
    call sprint
    db PRINTAT,16,2,"Lives: ", PRINTDECIMAL8 ;PRINTINK, 2*8+7,
    dw player_lives
    db PRINTAT,104,2,PRINTINK, 56,"Other: ", PRINTHEX16 ;PRINTINK, 2*8+7,
    dw debug_data_1
    db PRINTEOF
    ret

check_game_status:
    ld a, (player_dead)
    or a
    ret z
    ld a, (player_lives)
    or a
    jp nz, respawn
    jp new_game
    ret
