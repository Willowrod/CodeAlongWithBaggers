enter_layer_2:
    ld bc, LAYER_2_ACCESS_PORT
    ld a,2
    out (c),a
    ret

exit_layer_2:
    ld bc, LAYER_2_ACCESS_PORT
    xor a
    out (c),a
    ret