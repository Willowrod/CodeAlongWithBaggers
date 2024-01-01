;defines

CPU_SPEED                   EQU $07
SPEED_3_5_MHZ               EQU $00
SPEED_7_MHZ                 EQU $01
SPEED_14_MHZ                EQU $02
SPEED_28_MHZ                EQU $03

SPR_SELECT                  EQU $34
SPR_X_VALUE                 EQU $35
SPR_Y_VALUE                 EQU $36
SPR_X_MSB_FLIP              EQU $37
SPR_PATTERN                 EQU $38
SPR_ATTRIBUTES              EQU $39

SPR_X_VALUE_INC             EQU $75
SPR_Y_VALUE_INC             EQU $76
SPR_X_MSB_FLIP_INC          EQU $77
SPR_PATTERN_INC             EQU $78
SPR_ATTRIBUTES_INC          EQU $79

Z80_DMA_DATAGEAR_PORT       EQU $6b
SPR_IMAGE_PORT              EQU $5b
DMA_LOAD                    EQU $cf
DMA_DISABLE                 EQU $83
DMA_ENABLE                  EQU $87

SPR_LAYER_CONTROL           EQU $15

; Layer 2 specific

LAYER_2_ACCESS_PORT         EQU $123B
NEXTREG_REG_SELECT_PORT     EQU $243B
NEXTREG_REG_ACCESS_PORT     EQU $253B
SPRITE_SLOT_SELECT_PORT     EQU $303B

; Memory banks

MMU_REGISTER_0              EQU $50
MMU_REGISTER_1              EQU $51
MMU_REGISTER_2              EQU $52
MMU_REGISTER_3              EQU $53
MMU_REGISTER_4              EQU $54
MMU_REGISTER_5              EQU $55
MMU_REGISTER_6              EQU $56
MMU_REGISTER_7              EQU $57


; print codes

PRINTAT                     EQU 22
PRINTINK                    EQU 16
PRINTCLS                    EQU 12
PRINTDECIMAL8               EQU 14
PRINTDECIMAL16              EQU 15
PRINTHEX8                   EQU 17
PRINTHEX16                  EQU 18
PRINTEOF                    EQU 0


; characters


