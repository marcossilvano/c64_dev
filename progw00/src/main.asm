;
; Changing Border and Background Colors
;
delay = 127

*=$0801
!byte $0c,$08,$b5,$07,$9e,$20,$32,$30,$36,$32,$00,$00,$00
jmp main

!zone FnWaitVSync {
FnWaitVSync
.wait_vsync
    lda $d012
    cmp #$05
    bne .wait_vsync
    rts
}

!zone Main {
main
    ldx #delay

.colors_loop
    jsr FnWaitVSync    

    dex             ; delay 20 frames to change color
    bpl .colors_loop
    ldx #delay

    inc $d020       ;  border color (bits #0-#3)
    dec $d021       ;  background color (bits #0-#3)
    jmp .colors_loop

    rts
}
