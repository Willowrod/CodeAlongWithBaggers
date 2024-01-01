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

clear_layer_2:
    ld e,0
clear_layer_2_with_e:
    ld a,9
    call clearbank
    ld a,10
    call clearbank
    ld a,11
    jp clearbank ;will return from clearbank

