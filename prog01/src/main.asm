;
; Example
;

*=$0801
!byte $0c,$08,$b5,$07,$9e,$20,$32,$30,$36,$32,$00,$00,$00
jmp Main

clrscr = 147
fnprint= $ffd2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Data

hellotext
    ;!pet "hello, world! another world!",0
    !scr "hello, world! another world!",0
numbers
    !scr "0123456789",0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subroutine Print Lines at Screen

!zone FnPrinHeader {
FnPrinHeader
    ldx #0
    lda #"0"            ; char "0" / #48
    
.print_loop             
    cmp #":"            ; first char afet "9" in petscii
    beq .end_of_numbers

    jsr fnprint
    adc #1              ; increment petscii code in accumulator
    jmp .print_loop

.end_of_numbers
    lda #"0"            ; reset accumulator to char "0"
    
    inx                 
    cpx #4              ; if have printed 4x strings, return
    beq .return
    
    jmp .print_loop

.return
    ;lda #13
    ;jsr fnprint         ; \n
    rts
}

!zone FnPrintLineLabels {
FnPrintLineLabels
    lda #"1"
    ldx #0

.print_loop
    cmp #":"
    beq .end_of_numbers
    
    jsr fnprint
    adc #1

    inx
    cpx #22
    beq .return
    
    tay                 ; temporarily put a into y, print \n, and restore a
    lda #13
    jsr fnprint
    tya

    jmp .print_loop

.end_of_numbers
    lda #"0"
    jmp .print_loop

.return
    rts    
}

!zone FnPrintLines {
FnPrintLines
    lda #clrscr
    jsr fnprint

    jsr FnPrinHeader
    jsr FnPrintLineLabels

    rts
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subroutine Print String
ofs = 50
posx = 5
posy = 12
color_adr = $d800
screen_adr= $400

!zone FnPrintString {
FnPrintString
    lda #clrscr     ; clear screen code
    jsr fnprint    ; print(a)

    ldy #0
str_loop
    lda hellotext,y
    beq .return
    sta screen_adr+(posy*40+posx),y
    tya
    sta color_adr+(posy*40+posx),y
    iny
    jmp str_loop
.return
    rts
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Main

Main
    jsr FnPrintLines
    ;jsr FnPrintString
    rts
