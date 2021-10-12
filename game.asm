draw_boundries:   
    ld e,0
boxloop:
    ld d,0
    call plot
    ld d,191
    call plot
    ld d,e
    ld e,0
    call plot
    ld e,255
    call plot
    ld e,d
    inc e
    jr nz, boxloop
    ret
