; Provided under the CC0 license. See the included LICENSE.txt for details.

 processor 6502
 include "vcs.h"
 include "macro.h"
 include "multisprite.h"
 include "2600basic_variable_redefs.h"
 ifconst bankswitch
  if bankswitch == 8
     ORG $1000
     RORG $D000
  endif
  if bankswitch == 16
     ORG $1000
     RORG $9000
  endif
  if bankswitch == 32
     ORG $1000
     RORG $1000
  endif
  if bankswitch == 64
     ORG $1000
     RORG $1000
  endif
 else
   ORG $F000
 endif

 ifconst bankswitch_hotspot
 if bankswitch_hotspot = $083F ; 0840 bankswitching hotspot
   .byte 234 ; stop unexpected bankswitches
 endif
 endif
game
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L00 ;  includesfile multisprite_bankswitch.inc

.L01 ;  set kernel_options no_blank_lines

.L02 ;  set kernel multisprite

.L03 ;  set romsize 8k

.
 ; 

.
 ; 

.
 ; 

.L04 ;  scorecolor  =  14

	LDA #14
	STA scorecolor
.
 ; 

.L05 ;  dim _sc3  =  score + 2

.
 ; 

.
 ; 

.L06 ;  dim inv_x  =  a  :  a  =  84

	LDA #84
	STA a
.L07 ;  dim inv_y  =  b  :  b  =  76

	LDA #76
	STA b
.L08 ;  dim inv_delay  =  c  :  c  =  0

	LDA #0
	STA c
.L09 ;  dim inv_dir  =  f  :  f  =  1

	LDA #1
	STA f
.L010 ;  dim inv_shot_x  =  g  :  g  =  0

	LDA #0
	STA g
.L011 ;  dim inv_shot_y  =  h  :  h  =  0

	LDA #0
	STA h
.L012 ;  dim inv_fire_delay  =  k  :  k  =  0

	LDA #0
	STA k
.L013 ;  dim inv_fired  =  l  :  l  =  0

	LDA #0
	STA l
.L014 ;  dim inv_hit  =  n  :  n  =  0

	LDA #0
	STA n
.L015 ;  dim inv_blast_delay  =  o  :  o  =  0

	LDA #0
	STA o
.
 ; 

.
 ; 

.L016 ;  dim tur_x  =  d  :  d  =  84

	LDA #84
	STA d
.L017 ;  dim tur_y  =  e  :  e  =  14

	LDA #14
	STA e
.L018 ;  dim shot_x  =  i  :  i  =  tur_x

	LDA tur_x
	STA i
.L019 ;  dim shot_y  =  j  :  j  =  tur_y

	LDA tur_y
	STA j
.L020 ;  dim tur_fired  =  m  :  m  =  0

	LDA #0
	STA m
.
 ; 

.
 ; 

.
 ; 

.main
 ; main

.
 ; 

.L021 ;  gosub draw__move_turret

 jsr .draw__move_turret

.L022 ;  gosub draw__move_turret_shot

 jsr .draw__move_turret_shot

.L023 ;  gosub draw__move_invader

 jsr .draw__move_invader

.L024 ;  gosub draw__move_inv_shot

 jsr .draw__move_inv_shot

.L025 ;  gosub col_shot_inv

 jsr .col_shot_inv

.
 ; 

.L026 ;  if _sc3  >=  70 then goto game_over

	LDA _sc3
	CMP #70
     BCC .skipL026
.condpart0
 jmp .game_over

.skipL026
.
 ; 

.L027 ;  drawscreen

 sta temp7
 lda #>(ret_point1-1)
 pha
 lda #<(ret_point1-1)
 pha
 lda #>(drawscreen-1)
 pha
 lda #<(drawscreen-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #2
 jmp BS_jsr
ret_point1
.
 ; 

.L028 ;  goto main

 jmp .main

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.draw__move_invader
 ; draw__move_invader

.
 ; 

.L029 ;  inv_delay  =  inv_delay  +  1

	INC inv_delay
.
 ; 

.
 ; 

.L030 ;  if inv_delay  =  15  &&  inv_hit  =  0 then player0:  

	LDA inv_delay
	CMP #15
     BNE .skipL030
.condpart1
	LDA inv_hit
	CMP #0
     BNE .skip1then
.condpart2
	LDX #<player2then_0
	STX player0pointerlo
	LDA #>player2then_0
	STA player0pointerhi
	LDA #9
	STA player0height
.skip1then
.skipL030
.
 ; 

.
 ; 

.L031 ;  if inv_delay  =  30  &&  inv_hit  =  0 then player0:  

	LDA inv_delay
	CMP #30
     BNE .skipL031
.condpart3
	LDA inv_hit
	CMP #0
     BNE .skip3then
.condpart4
	LDX #<player4then_0
	STX player0pointerlo
	LDA #>player4then_0
	STA player0pointerhi
	LDA #9
	STA player0height
.skip3then
.skipL031
.
 ; 

.L032 ;  if inv_delay  >  30 then inv_delay  =  0

	LDA #30
	CMP inv_delay
     BCS .skipL032
.condpart5
	LDA #0
	STA inv_delay
.skipL032
.
 ; 

.
 ; 

.L033 ;  COLUP0  =  52

	LDA #52
	STA COLUP0
.
 ; 

.
 ; 

.L034 ;  if inv_hit  =  0  &&  inv_dir  =  1  &&  inv_delay  =  15 then inv_x  =  inv_x  +  1

	LDA inv_hit
	CMP #0
     BNE .skipL034
.condpart6
	LDA inv_dir
	CMP #1
     BNE .skip6then
.condpart7
	LDA inv_delay
	CMP #15
     BNE .skip7then
.condpart8
	INC inv_x
.skip7then
.skip6then
.skipL034
.L035 ;  if inv_hit  =  0  &&  inv_dir  =  1  &&  inv_delay  =  30 then inv_x  =  inv_x  +  1

	LDA inv_hit
	CMP #0
     BNE .skipL035
.condpart9
	LDA inv_dir
	CMP #1
     BNE .skip9then
.condpart10
	LDA inv_delay
	CMP #30
     BNE .skip10then
.condpart11
	INC inv_x
.skip10then
.skip9then
.skipL035
.
 ; 

.L036 ;  if inv_x  >  143 then inv_dir  =  0  :  inv_x  =  143  :  inv_y  =  inv_y  -  5

	LDA #143
	CMP inv_x
     BCS .skipL036
.condpart12
	LDA #0
	STA inv_dir
	LDA #143
	STA inv_x
	LDA inv_y
	SEC
	SBC #5
	STA inv_y
.skipL036
.
 ; 

.
 ; 

.L037 ;  if inv_hit  =  0  &&  inv_dir  =  0  &&  inv_delay  =  15 then inv_x  =  inv_x  -  1

	LDA inv_hit
	CMP #0
     BNE .skipL037
.condpart13
	LDA inv_dir
	CMP #0
     BNE .skip13then
.condpart14
	LDA inv_delay
	CMP #15
     BNE .skip14then
.condpart15
	DEC inv_x
.skip14then
.skip13then
.skipL037
.L038 ;  if inv_hit  =  0  &&  inv_dir  =  0  &&  inv_delay  =  30 then inv_x  =  inv_x  -  1

	LDA inv_hit
	CMP #0
     BNE .skipL038
.condpart16
	LDA inv_dir
	CMP #0
     BNE .skip16then
.condpart17
	LDA inv_delay
	CMP #30
     BNE .skip17then
.condpart18
	DEC inv_x
.skip17then
.skip16then
.skipL038
.
 ; 

.L039 ;  if inv_x  <  26 then inv_dir  =  1  :  inv_x  =  26  :  inv_y  =  inv_y  -  5

	LDA inv_x
	CMP #26
     BCS .skipL039
.condpart19
	LDA #1
	STA inv_dir
	LDA #26
	STA inv_x
	LDA inv_y
	SEC
	SBC #5
	STA inv_y
.skipL039
.
 ; 

.
 ; 

.L040 ;  player0x  =  inv_x  -  8  :  player0y  =  inv_y

	LDA inv_x
	SEC
	SBC #8
	STA player0x
	LDA inv_y
	STA player0y
.L041 ;  return

	tsx
	lda 2,x ; check return address
	eor #(>*) ; vs. current PCH
	and #$E0 ;  mask off all but top 3 bits
	beq *+5 ; if equal, do normal return
	JMP BS_return
	RTS
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.draw__move_inv_shot
 ; draw__move_inv_shot

.
 ; 

.L042 ;  player2:

	LDX #<playerL042_2
	STX player2pointerlo
	LDA #>playerL042_2
	STA player2pointerhi
	LDA #9
	STA player2height
.
 ; 

.L043 ;  COLUP2  =  14

	LDA #14
	STA COLUP2
.
 ; 

.L044 ;  inv_fire_delay  =  inv_fire_delay  +  1

	INC inv_fire_delay
.
 ; 

.L045 ;  if inv_fired  =  0  &&  inv_fire_delay  =  180 then inv_shot_x  =  inv_x  :  inv_shot_y  =  inv_y  -  9

	LDA inv_fired
	CMP #0
     BNE .skipL045
.condpart20
	LDA inv_fire_delay
	CMP #180
     BNE .skip20then
.condpart21
	LDA inv_x
	STA inv_shot_x
	LDA inv_y
	SEC
	SBC #9
	STA inv_shot_y
.skip20then
.skipL045
.L046 ;  if inv_fired  =  0  &&  inv_fire_delay  =  180 then player2x  =  inv_shot_x  :  player2y  =  inv_shot_y

	LDA inv_fired
	CMP #0
     BNE .skipL046
.condpart22
	LDA inv_fire_delay
	CMP #180
     BNE .skip22then
.condpart23
	LDA inv_shot_x
	STA player2x
	LDA inv_shot_y
	STA player2y
.skip22then
.skipL046
.L047 ;  if inv_fired  =  0  &&  inv_fire_delay  =  180 then inv_fired  =  1

	LDA inv_fired
	CMP #0
     BNE .skipL047
.condpart24
	LDA inv_fire_delay
	CMP #180
     BNE .skip24then
.condpart25
	LDA #1
	STA inv_fired
.skip24then
.skipL047
.
 ; 

.L048 ;  if inv_fired  =  1 then inv_shot_y  =  inv_shot_y  -  2  :  player2y  =  inv_shot_y

	LDA inv_fired
	CMP #1
     BNE .skipL048
.condpart26
	LDA inv_shot_y
	SEC
	SBC #2
	STA inv_shot_y
	LDA inv_shot_y
	STA player2y
.skipL048
.
 ; 

.L049 ;  if inv_shot_y  <  12 then inv_fired  =  0  :  inv_fire_delay  =  0  :  inv_shot_y  =  88  :  player2y  =  inv_shot_y

	LDA inv_shot_y
	CMP #12
     BCS .skipL049
.condpart27
	LDA #0
	STA inv_fired
	STA inv_fire_delay
	LDA #88
	STA inv_shot_y
	LDA inv_shot_y
	STA player2y
.skipL049
.
 ; 

.L050 ;  return

	tsx
	lda 2,x ; check return address
	eor #(>*) ; vs. current PCH
	and #$E0 ;  mask off all but top 3 bits
	beq *+5 ; if equal, do normal return
	JMP BS_return
	RTS
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.col_shot_inv
 ; col_shot_inv

.L051 ;  if shot_x  +  3  >=  inv_x  &&  shot_x  +  3  <=  inv_x  +  6  &&  shot_y  >  inv_y then inv_hit  =  1

; complex condition detected
	LDA shot_x
	CLC
	ADC #3
; todo: this LDA is spurious and should be prevented ->	LDA  1,x
	CMP inv_x
     BCC .skipL051
.condpart28
; complex condition detected
	LDA inv_x
	CLC
	ADC #6
  PHA
	LDA shot_x
	CLC
	ADC #3
  PHA
  TSX
  PLA
  PLA
; todo: this LDA is spurious and should be prevented ->	LDA  2,x
	CMP  1,x
     BCC .skip28then
.condpart29
	LDA inv_y
	CMP shot_y
     BCS .skip29then
.condpart30
	LDA #1
	STA inv_hit
.skip29then
.skip28then
.skipL051
.
 ; 

.L052 ;  if inv_hit  =  1 then inv_blast_delay  =  inv_blast_delay  +  1

	LDA inv_hit
	CMP #1
     BNE .skipL052
.condpart31
	INC inv_blast_delay
.skipL052
.
 ; 

.L053 ;  if inv_blast_delay  >  30 then score  =  score  +  10  :  inv_hit  =  0  :  gosub reset_blast

	LDA #30
	CMP inv_blast_delay
     BCS .skipL053
.condpart32
	SED
	CLC
	LDA score+2
	ADC #$10
	STA score+2
	LDA score+1
	ADC #$00
	STA score+1
	LDA score
	ADC #$00
	STA score
	CLD
	LDA #0
	STA inv_hit
 jsr .reset_blast

.skipL053
.
 ; 

.L054 ;  if inv_hit  =  1 then player0:  

	LDA inv_hit
	CMP #1
     BNE .skipL054
.condpart33
	LDX #<player33then_0
	STX player0pointerlo
	LDA #>player33then_0
	STA player0pointerhi
	LDA #9
	STA player0height
.skipL054
.
 ; 

.L055 ;  return

	tsx
	lda 2,x ; check return address
	eor #(>*) ; vs. current PCH
	and #$E0 ;  mask off all but top 3 bits
	beq *+5 ; if equal, do normal return
	JMP BS_return
	RTS
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.reset_blast
 ; reset_blast

.L056 ;  player0:  

	LDX #<playerL056_0
	STX player0pointerlo
	LDA #>playerL056_0
	STA player0pointerhi
	LDA #9
	STA player0height
.
 ; 

.
 ; 

.L057 ;  inv_blast_delay  =  0  :  inv_x  =   ( rand & 117 )   +  26  :  inv_y  =  76

	LDA #0
	STA inv_blast_delay
; complex statement detected
 sta temp7
 lda #>(ret_point2-1)
 pha
 lda #<(ret_point2-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #2
 jmp BS_jsr
ret_point2
	AND #117
	CLC
	ADC #26
	STA inv_x
	LDA #76
	STA inv_y
.
 ; 

.L058 ;  return

	tsx
	lda 2,x ; check return address
	eor #(>*) ; vs. current PCH
	and #$E0 ;  mask off all but top 3 bits
	beq *+5 ; if equal, do normal return
	JMP BS_return
	RTS
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.draw__move_turret
 ; draw__move_turret

.L059 ;  player1:

	LDX #<playerL059_1
	STX player1pointerlo
	LDA #>playerL059_1
	STA player1pointerhi
	LDA #9
	STA player1height
.
 ; 

.
 ; 

.L060 ;  _COLUP1  =  196

	LDA #196
	STA _COLUP1
.
 ; 

.L061 ;  if joy0left  &&  tur_x  >=  26 then tur_x  =  tur_x  -  1

 bit SWCHA
	BVS .skipL061
.condpart34
	LDA tur_x
	CMP #26
     BCC .skip34then
.condpart35
	DEC tur_x
.skip34then
.skipL061
.L062 ;  if joy0right  &&  tur_x  <=  143 then tur_x  =  tur_x  +  1

 bit SWCHA
	BMI .skipL062
.condpart36
	LDA #143
	CMP tur_x
     BCC .skip36then
.condpart37
	INC tur_x
.skip36then
.skipL062
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L063 ;  player1x  =  tur_x  :  player1y  =  tur_y

	LDA tur_x
	STA player1x
	LDA tur_y
	STA player1y
.
 ; 

.L064 ;  return

	tsx
	lda 2,x ; check return address
	eor #(>*) ; vs. current PCH
	and #$E0 ;  mask off all but top 3 bits
	beq *+5 ; if equal, do normal return
	JMP BS_return
	RTS
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.draw__move_turret_shot
 ; draw__move_turret_shot

.L065 ;  player3:

	LDX #<playerL065_3
	STX player3pointerlo
	LDA #>playerL065_3
	STA player3pointerhi
	LDA #9
	STA player3height
.
 ; 

.L066 ;  COLUP3  =  14

	LDA #14
	STA COLUP3
.
 ; 

.L067 ;  if joy0fire  &&  tur_fired  =  0 then tur_fired  =  1  :  shot_x  =  tur_x  :  shot_y  =  tur_y  +  1  :  player3x  =  shot_x  :  player3y  =  shot_y

 bit INPT4
	BMI .skipL067
.condpart38
	LDA tur_fired
	CMP #0
     BNE .skip38then
.condpart39
	LDA #1
	STA tur_fired
	LDA tur_x
	STA shot_x
	LDA tur_y
	CLC
	ADC #1
	STA shot_y
	LDA shot_x
	STA player3x
	LDA shot_y
	STA player3y
.skip38then
.skipL067
.
 ; 

.L068 ;  if tur_fired  =  1 then shot_y  =  shot_y  +  2  :  player3x  =  shot_x  :  player3y  =  shot_y

	LDA tur_fired
	CMP #1
     BNE .skipL068
.condpart40
	LDA shot_y
	CLC
	ADC #2
	STA shot_y
	LDA shot_x
	STA player3x
	LDA shot_y
	STA player3y
.skipL068
.
 ; 

.L069 ;  if shot_y  >  77 then tur_fired  =  0  :  shot_y  =  0  :  player3y  =  shot_y

	LDA #77
	CMP shot_y
     BCS .skipL069
.condpart41
	LDA #0
	STA tur_fired
	STA shot_y
	LDA shot_y
	STA player3y
.skipL069
.
 ; 

.L070 ;  return

	tsx
	lda 2,x ; check return address
	eor #(>*) ; vs. current PCH
	and #$E0 ;  mask off all but top 3 bits
	beq *+5 ; if equal, do normal return
	JMP BS_return
	RTS
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.game_over
 ; game_over

.
 ; 

.L071 ;  if joy0up then reboot

 lda #$10
 bit SWCHA
	BNE .skipL071
.condpart42
	JMP ($FFFC)
.skipL071
.
 ; 

.L072 ;  score  =  50

	LDA #$50
	STA score+2
	LDA #$00
	STA score+1
	LDA #$00
	STA score
.
 ; 

.L073 ;  player2:

	LDX #<playerL073_2
	STX player2pointerlo
	LDA #>playerL073_2
	STA player2pointerhi
	LDA #26
	STA player2height
.
 ; 

.L074 ;  player3:

	LDX #<playerL074_3
	STX player3pointerlo
	LDA #>playerL074_3
	STA player3pointerhi
	LDA #26
	STA player3height
.
 ; 

.L075 ;  rem  ; GA

.L076 ;  rem  player2:

.L077 ;  rem  %00000000

.L078 ;  rem  %00000000

.L079 ;  rem  %11101010

.L080 ;  rem  %10101010

.L081 ;  rem  %10101110

.L082 ;  rem  %10001010

.L083 ;  rem  %10001010

.L084 ;  rem  %11101110

.L085 ;  rem end

.L086 ;  rem  COLUP2 = 14

.L087 ;  rem 

.L088 ;  rem  ; ME

.L089 ;  rem  player3:

.L090 ;  rem  %00000000

.L091 ;  rem  %00000000

.L092 ;  rem  %10101110

.L093 ;  rem  %10101000

.L094 ;  rem  %10101000

.L095 ;  rem  %10101100

.L096 ;  rem  %11101000

.L097 ;  rem  %10101110

.L098 ;  rem end

.L099 ;  rem  COLUP3 = 14

.L0100 ;  rem 

.L0101 ;  rem  ; OV

.L0102 ;  rem  player4:

.L0103 ;  rem  %00000000

.L0104 ;  rem  %00000000

.L0105 ;  rem  %11100100

.L0106 ;  rem  %10101010

.L0107 ;  rem  %10101010

.L0108 ;  rem  %10101010

.L0109 ;  rem  %10101010

.L0110 ;  rem  %11101010

.L0111 ;  rem end

.L0112 ;  rem  COLUP4 = 14

.L0113 ;  rem 

.L0114 ;  rem  ; ER

.L0115 ;  rem  player5:

.L0116 ;  rem  %00000000

.L0117 ;  rem  %00000000

.L0118 ;  rem  %11101010

.L0119 ;  rem  %10001010

.L0120 ;  rem  %11001010

.L0121 ;  rem  %10001100

.L0122 ;  rem  %10001010

.L0123 ;  rem  %11101100

.L0124 ;  rem end

.L0125 ;  rem  COLUP5 = 14

.
 ; 

.L0126 ;  player0x  =  0  :  player0y  =  0

	LDA #0
	STA player0x
	STA player0y
.L0127 ;  player1x  =  0  :  player1y  =  0

	LDA #0
	STA player1x
	STA player1y
.L0128 ;  COLUP0  =  0

	LDA #0
	STA COLUP0
.L0129 ;  COLUP1  =  0

	LDA #0
	STA COLUP1
.
 ; 

.L0130 ;  player2x  =  85  :  player2y  =  66

	LDA #85
	STA player2x
	LDA #66
	STA player2y
.L0131 ;  player3x  =  85  :  player3y  =  39

	LDA #85
	STA player3x
	LDA #39
	STA player3y
.
 ; 

.L0132 ;  rem player2x = 70 : player2y = 50

.L0133 ;  rem  player3x = 78 : player3y = 50

.L0134 ;  rem  player4x = 86 : player4y = 50

.L0135 ;  rem  player5x = 94 : player5y = 50

.L0136 ;  rem 

.
 ; 

.L0137 ;  drawscreen

 sta temp7
 lda #>(ret_point3-1)
 pha
 lda #<(ret_point3-1)
 pha
 lda #>(drawscreen-1)
 pha
 lda #<(drawscreen-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #2
 jmp BS_jsr
ret_point3
.
 ; 

.L0138 ;  goto game_over

 jmp .game_over

 if ECHO1
 echo "    ",[(start_bank1 - *)]d , "bytes of ROM space left in bank 1")
 endif
ECHO1 = 1
 ORG $1FF4-bscode_length
 RORG $DFF4-bscode_length
start_bank1 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif 
 txs
 if bankswitch == 64
   lda #(((>(start-1)) & $0F) | $F0)
 else
   lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha
 pha
 txa
 pha
 tsx
 if bankswitch != 64
   lda 4,x ; get high byte of return address
   rol
   rol
   rol
   rol
   and #bs_mask ;1 3 or 7 for F8/F6/F4
   tax
   inx
 else
   lda 4,x ; get high byte of return address
   tay
   ora #$10 ; change our bank nibble into a valid rom mirror
   sta 4,x
   tya
   lsr 
   lsr 
   lsr 
   lsr 
   tax
   inx
 endif
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
   echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
   echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ORG $1FFC
 RORG $DFFC
 .word (start_bank1 & $ffff)
 .word (start_bank1 & $ffff)
 ORG $2000
 RORG $F000
; Provided under the CC0 license. See the included LICENSE.txt for details.

FineAdjustTableBegin
	.byte %01100000		;left 6
	.byte %01010000
	.byte %01000000
	.byte %00110000
	.byte %00100000
	.byte %00010000
	.byte %00000000		;left 0
	.byte %11110000
	.byte %11100000
	.byte %11010000
	.byte %11000000
	.byte %10110000
	.byte %10100000
	.byte %10010000
	.byte %10000000		;right 8
FineAdjustTableEnd	=	FineAdjustTableBegin - 241

PFStart
 .byte 87,43,0,21,0,0,0,10
blank_pf
 .byte 0,0,0,0,0,0,0,5
; .byte 43,21,0,10,0,0,0,5
 ifconst screenheight
pfsub
 .byte 8,4,2,2,1,0,0,1,0
 endif
	;--set initial P1 positions
multisprite_setup
 lda #15
 sta pfheight

	ldx #4
; stx temp3
SetCopyHeight
;	lda #76
;	sta NewSpriteX,X
;	lda CopyColorData,X
;	sta NewCOLUP1,X
 ;lda SpriteHeightTable,X
; sta spriteheight,x
	txa
	sta SpriteGfxIndex,X
	sta spritesort,X
	dex
	bpl SetCopyHeight



; since we can't turn off pf, point PF to zeros here
 lda #>blank_pf
 sta PF2pointer+1
 sta PF1pointer+1
 lda #<blank_pf
 sta PF2pointer
 sta PF1pointer
 rts

drawscreen
 ifconst debugscore
 jsr debugcycles
 endif

WaitForOverscanEnd
	lda INTIM
	bmi WaitForOverscanEnd

	lda #2
	sta WSYNC
	sta VSYNC
	sta WSYNC
	sta WSYNC
	lsr
	sta VDELBL
	sta VDELP0
	sta WSYNC
	sta VSYNC	;turn off VSYNC
      ifconst overscan_time
        lda #overscan_time+5+128
      else
	lda #42+128
      endif
	sta TIM64T

; run possible vblank bB code
 ifconst vblank_bB_code
   jsr vblank_bB_code
 endif

 	jsr setscorepointers
	jsr SetupP1Subroutine

	;-------------





	;--position P0, M0, M1, BL

	jsr PrePositionAllObjects

	;--set up player 0 pointer

 dec player0y
	lda player0pointer ; player0: must be run every frame!
	sec
	sbc player0y
	clc
	adc player0height
	sta player0pointer

	lda player0y
	sta P0Top
	sec
	sbc player0height
	clc
	adc #$80
	sta P0Bottom
	

	;--some final setup

 ldx #4
 lda #$80
cycle74_HMCLR
 sta HMP0,X
 dex
 bpl cycle74_HMCLR
;	sta HMCLR


	lda #0
	sta PF1
	sta PF2
	sta GRP0
	sta GRP1


	jsr KernelSetupSubroutine

WaitForVblankEnd
	lda INTIM
	bmi WaitForVblankEnd
        lda #0
	sta WSYNC
	sta VBLANK	;turn off VBLANK - it was turned on by overscan
	sta CXCLR


	jmp KernelRoutine


PositionASpriteSubroutine	;call this function with A == horizontal position (0-159)
				;and X == the object to be positioned (0=P0, 1=P1, 2=M0, etc.)
				;if you do not wish to write to P1 during this function, make
				;sure Y==0 before you call it.  This function will change Y, and A
				;will be the value put into HMxx when returned.
				;Call this function with at least 11 cycles left in the scanline 
				;(jsr + sec + sta WSYNC = 11); it will return 9 cycles
				;into the second scanline
	sec
	sta WSYNC			;begin line 1
	sta.w HMCLR			;+4	 4
DivideBy15Loop
	sbc #15
	bcs DivideBy15Loop			;+4/5	8/13.../58

	tay				;+2	10/15/...60
	lda FineAdjustTableEnd,Y	;+5	15/20/...65

			;	15
	sta HMP0,X	;+4	19/24/...69
	sta RESP0,X	;+4	23/28/33/38/43/48/53/58/63/68/73
	sta WSYNC	;+3	 0	begin line 2
	sta HMOVE	;+3
	rts		;+6	 9

;-------------------------------------------------------------------------

PrePositionAllObjects

	ldx #4
	lda ballx
	jsr PositionASpriteSubroutine
	
	dex
	lda missile1x
	jsr PositionASpriteSubroutine
	
	dex
	lda missile0x
	jsr PositionASpriteSubroutine

	dex
	dex
	lda player0x
	jsr PositionASpriteSubroutine

	rts


;-------------------------------------------------------------------------








;-------------------------------------------------------------------------


KernelSetupSubroutine

	ldx #4
AdjustYValuesUpLoop
	lda NewSpriteY,X
	clc
	adc #2
	sta NewSpriteY,X
	dex
	bpl AdjustYValuesUpLoop


	ldx temp3 ; first sprite displayed

	lda SpriteGfxIndex,x
	tay
	lda NewSpriteY,y
	sta RepoLine

	lda SpriteGfxIndex-1,x
	tay
	lda NewSpriteY,y
	sta temp6

	stx SpriteIndex



	lda #255
	sta P1Bottom

	lda player0y
 ifconst screenheight
	cmp #screenheight+1
 else
	cmp #$59
 endif
	bcc nottoohigh
	lda P0Bottom
	sta P0Top		

       

nottoohigh
	rts

;-------------------------------------------------------------------------





;*************************************************************************

;-------------------------------------------------------------------------
;-------------------------Data Below--------------------------------------
;-------------------------------------------------------------------------

MaskTable
	.byte 1,3,7,15,31

 ; shove 6-digit score routine here

sixdigscore
	lda #0
;	sta COLUBK
	sta PF0
	sta PF1
	sta PF2
	sta ENABL
	sta ENAM0
	sta ENAM1
	;end of kernel here


 ; 6 digit score routine
; lda #0
; sta PF1
; sta PF2
; tax

   sta WSYNC;,x

;                STA WSYNC ;first one, need one more
 sta REFP0
 sta REFP1
                STA GRP0
                STA GRP1
 sta HMCLR

 ; restore P0pointer

	lda player0pointer
	clc
	adc player0y
	sec
	sbc player0height
	sta player0pointer
 inc player0y

 ifconst vblank_time
 ifconst screenheight
 if screenheight == 84
	lda  #vblank_time+9+128+10
 else
	lda  #vblank_time+9+128+19
 endif
 else
	lda  #vblank_time+9+128
 endif
 else
 ifconst screenheight
 if screenheight == 84
	lda  #52+128+10
 else
	lda  #52+128+19
 endif
 else
	lda  #52+128
 endif
 endif

	sta  TIM64T
 ifconst minikernel
 jsr minikernel
 endif
 ifconst noscore
 pla
 pla
 jmp skipscore
 endif

; score pointers contain:
; score1-5: lo1,lo2,lo3,lo4,lo5,lo6
; swap lo2->temp1
; swap lo4->temp3
; swap lo6->temp5

 lda scorepointers+5
 sta temp5
 lda scorepointers+1
 sta temp1
 lda scorepointers+3
 sta temp3

 lda #>scoretable
 sta scorepointers+1
 sta scorepointers+3
 sta scorepointers+5
 sta temp2
 sta temp4
 sta temp6

 rts



;-------------------------------------------------------------------------
;----------------------Kernel Routine-------------------------------------
;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
; repeat $f147-*
; brk
; repend
;	org $F240

SwitchDrawP0K1				;	72
	lda P0Bottom
	sta P0Top			;+6	 2
	jmp BackFromSwitchDrawP0K1	;+3	 5

WaitDrawP0K1				;	74
	SLEEP 4				;+4	 2
	jmp BackFromSwitchDrawP0K1	;+3	 5

SkipDrawP1K1				;	11
	lda #0
	sta GRP1			;+5	16	so Ball gets drawn
	jmp BackFromSkipDrawP1		;+3	19

;-------------------------------------------------------------------------

KernelRoutine
 ifnconst screenheight
 sleep 12
 ; jsr wastetime ; waste 12 cycles
 else
 sleep 6
 endif
	tsx
	stx stack1
	ldx #ENABL
	txs			;+9	 9

 ldx #0
 lda pfheight
 bpl asdhj
 .byte $24
asdhj
 tax

; ldx pfheight
 lda PFStart,x ; get pf pixel resolution for heights 15,7,3,1,0

 ifconst screenheight
  sec
 if screenheight == 84
  sbc pfsub+1,x
 else
  sbc pfsub,x
 endif
 endif
 
 sta pfpixelheight

 ifconst screenheight
        ldy #screenheight
 else
	ldy #88
 endif
 
;	lda #$02
;	sta COLUBK		;+5	18

; sleep 25
 sleep 2
KernelLoopa			;	50
	SLEEP 7			;+4	54
KernelLoopb			;	54
	SLEEP 2		;+12	66
	cpy P0Top		;+3	69
	beq SwitchDrawP0K1	;+2	71
	bpl WaitDrawP0K1	;+2	73
	lda (player0pointer),Y	;+5	 2
	sta GRP0		;+3	 5	VDEL because of repokernel
BackFromSwitchDrawP0K1

	cpy P1Bottom		;+3	 8	unless we mean to draw immediately, this should be set
				;		to a value greater than maximum Y value initially
	bcc SkipDrawP1K1	;+2	10
	lda (P1display),Y	;+5	15
	sta.w GRP1		;+4	19
BackFromSkipDrawP1

;fuck	
 sty temp1
 ldy pfpixelheight
	lax (PF1pointer),y
	stx PF1			;+7	26
	lda (PF2pointer),y
	sta PF2			;+7	33
 ;sleep 6
	stx PF1temp2
	sta PF2temp2
	dey
 bmi pagewraphandler
	lda (PF1pointer),y
cyclebalance
	sta PF1temp1
	lda (PF2pointer),y
	sta PF2temp1
 ldy temp1

 ldx #ENABL
 txs
	cpy bally
	php			;+6	39	VDEL ball


	cpy missile1y
	php			;+6	71

	cpy missile0y
	php			;+6	 1
	

	dey			;+2	15

	cpy RepoLine		;+3	18
	beq RepoKernel		;+2	20
;	SLEEP 20		;+23	43
 sleep 6

newrepo ; since we have time here, store next repoline
 ldx SpriteIndex
 lda SpriteGfxIndex-1,x
 tax
 lda NewSpriteY,x
 sta temp6
 sleep 4 

BackFromRepoKernel
	tya			;+2	45
	and pfheight			;+2	47
	bne KernelLoopa		;+2	49
	dec pfpixelheight
	bpl KernelLoopb		;+3	54
;	bmi donewkernel		;+3	54
;	bne KernelLoopb+1		;+3	54

donewkernel
	jmp DoneWithKernel	;+3	56

pagewraphandler
 jmp cyclebalance

;-------------------------------------------------------------------------
 
 ; room here for score?

setscorepointers
 lax score+2
 jsr scorepointerset
 sty scorepointers+5
 stx scorepointers+2
 lax score+1
 jsr scorepointerset
 sty scorepointers+4
 stx scorepointers+1
 lax score
 jsr scorepointerset
 sty scorepointers+3
 stx scorepointers
wastetime
 rts

scorepointerset
 and #$0F
 asl
 asl
 asl
 adc #<scoretable
 tay
 txa
 and #$F0
 lsr
 adc #<scoretable
 tax
 rts
;	align 256

SwitchDrawP0KR				;	45
	lda P0Bottom
	sta P0Top			;+6	51
	jmp BackFromSwitchDrawP0KR	;+3	54

WaitDrawP0KR				;	47
	SLEEP 4				;+4	51
	jmp BackFromSwitchDrawP0KR	;+3	54

;-----------------------------------------------------------

noUpdateXKR
 ldx #1
 cpy.w P0Top
 JMP retXKR

skipthis
 ldx #1
 jmp goback

RepoKernel			;	22	crosses page boundary
	tya
	and pfheight			;+2	26
	bne noUpdateXKR		;+2	28
        tax
;	dex			;+2	30
	dec pfpixelheight
;	stx Temp		;+3	35
;	SLEEP 3

	cpy P0Top		;+3	42
retXKR
	beq SwitchDrawP0KR	;+2	44
	bpl WaitDrawP0KR	;+2	46
	lda (player0pointer),Y	;+5	51
	sta GRP0		;+3	54	VDEL
BackFromSwitchDrawP0KR
	sec			;+2	56
 


	lda PF2temp1,X
	ldy PF1temp1,X

	ldx SpriteIndex	;+3	 2

	sta PF2			;+7	63

	lda SpriteGfxIndex,x
	sty PF1			;+7	70	too early?
	tax
	lda #0
	sta GRP1		;+5	75	to display player 0
	lda NewSpriteX,X	;+4	 6
 
DivideBy15LoopK				;	 6	(carry set above)
	sbc #15
	bcs DivideBy15LoopK		;+4/5	10/15.../60

	tax				;+2	12/17/...62
	lda FineAdjustTableEnd,X	;+5	17/22/...67

	sta HMP1			;+3	20/25/...70
	sta RESP1			;+3	23/28/33/38/43/48/53/58/63/68/73
	sta WSYNC			;+3	 0	begin line 2
	;sta HMOVE			;+3	 3

	ldx #ENABL
	txs			;+4	25
	ldy RepoLine ; restore y
	cpy bally
	php			;+6	 9	VDEL ball

	cpy missile1y
	php			;+6	15

	cpy missile0y
	php			;+6	21
	

 


;15 cycles
	tya
	and pfheight
 ;eor #1
	and #$FE
	bne skipthis
 tax
 sleep 4
;	sleep 2
goback

	dey
	cpy P0Top			;+3	52
	beq SwitchDrawP0KV	;+2	54
	bpl WaitDrawP0KV		;+2	56
	lda (player0pointer),Y		;+5	61
	sta GRP0			;+3	64	VDEL
BackFromSwitchDrawP0KV

; sleep 3

	lda PF2temp1,X
	sta PF2			;+7	 5
	lda PF1temp1,X
	sta PF1			;+7	74 
 sta HMOVE

	lda #0
	sta GRP1			;+5	10	to display GRP0

	ldx #ENABL
	txs			;+4	 8

	ldx SpriteIndex	;+3	13	restore index into new sprite vars
	;--now, set all new variables and return to main kernel loop


;
	lda SpriteGfxIndex,X	;+4	31
	tax				;+2	33
;



	lda NewNUSIZ,X
	sta NUSIZ1			;+7	20
 sta REFP1
	lda NewCOLUP1,X
	sta COLUP1			;+7	27

;	lda SpriteGfxIndex,X	;+4	31
;	tax				;+2	33
;fuck2
	lda NewSpriteY,X		;+4	46
	sec				;+2	38
	sbc spriteheight,X	;+4	42
	sta P1Bottom		;+3	45

 sleep 6
	lda player1pointerlo,X	;+4	49
	sbc P1Bottom		;+3	52	carry should still be set
	sta P1display		;+3	55
	lda player1pointerhi,X
	sta P1display+1		;+7	62


	cpy bally
	php			;+6	68	VDELed

	cpy missile1y
	php			;+6	74

	cpy missile0y
	php			;+6	 4



; lda SpriteGfxIndex-1,x
; sleep 3
	dec SpriteIndex	;+5	13
; tax
; lda NewSpriteY,x
; sta RepoLine

; 10 cycles below...
	bpl SetNextLine
	lda #255
	jmp SetLastLine
SetNextLine
;	lda NewSpriteY-1,x
	lda.w temp6
SetLastLine
	sta RepoLine	

 tya
 and pfheight
 bne nodec
 dec pfpixelheight
	dey			;+2	30

; 10 cycles 
 

	jmp BackFromRepoKernel	;+3	43

nodec
 sleep 4
 dey
 jmp BackFromRepoKernel

;-------------------------------------------------------------------------


SwitchDrawP0KV				;	69
	lda P0Bottom
	sta P0Top			;+6	75
	jmp BackFromSwitchDrawP0KV	;+3	 2

WaitDrawP0KV				;	71
	SLEEP 4				;+4	75
	jmp BackFromSwitchDrawP0KV	;+3	 2

;-------------------------------------------------------------------------

DoneWithKernel

BottomOfKernelLoop

	sta WSYNC
 ldx stack1
 txs
 jsr sixdigscore ; set up score


 sta WSYNC
 ldx #0
 sta HMCLR
                STx GRP0
                STx GRP1 ; seems to be needed because of vdel

                LDY #7
        STy VDELP0
        STy VDELP1
        LDA #$10
        STA HMP1
               LDA scorecolor 
                STA COLUP0
                STA COLUP1
 
        LDA #$03
        STA NUSIZ0
        STA NUSIZ1

                STA RESP0
                STA RESP1

 sleep 9
 lda  (scorepointers),y
 sta  GRP0
 ifconst pfscore
 lda pfscorecolor
 sta COLUPF
 else
 sleep 6
 endif

                STA HMOVE
 lda  (scorepointers+8),y
; sta WSYNC
 ;sleep 2
 jmp beginscore


loop2
 lda  (scorepointers),y     ;+5  68  204
 sta  GRP0            ;+3  71  213      D1     --      --     --
 ifconst pfscore
 lda.w pfscore1
 sta PF1
 else
 sleep 7
 endif
 ; cycle 0
 lda  (scorepointers+$8),y  ;+5   5   15
beginscore
 sta  GRP1            ;+3   8   24      D1     D1      D2     --
 lda  (scorepointers+$6),y  ;+5  13   39
 sta  GRP0            ;+3  16   48      D3     D1      D2     D2
 lax  (scorepointers+$2),y  ;+5  29   87
 txs
 lax  (scorepointers+$4),y  ;+5  36  108
 sleep 3
 ifconst pfscore
 lda pfscore2
 sta PF1
 else
 sleep 6
 endif
 lda  (scorepointers+$A),y  ;+5  21   63
 stx  GRP1            ;+3  44  132      D3     D3      D4     D2!
 tsx
 stx  GRP0            ;+3  47  141      D5     D3!     D4     D4
 sta  GRP1            ;+3  50  150      D5     D5      D6     D4!
 sty  GRP0            ;+3  53  159      D4*    D5!     D6     D6
 dey
 bpl  loop2           ;+2  60  180
 	ldx stack1
	txs


; lda scorepointers+1
 ldy temp1
; sta temp1
 sty scorepointers+1

                LDA #0   
               STA GRP0
                STA GRP1
 sta PF1 
       STA VDELP0
        STA VDELP1;do we need these
        STA NUSIZ0
        STA NUSIZ1

; lda scorepointers+3
 ldy temp3
; sta temp3
 sty scorepointers+3

; lda scorepointers+5
 ldy temp5
; sta temp5
 sty scorepointers+5


;-------------------------------------------------------------------------
;------------------------Overscan Routine---------------------------------
;-------------------------------------------------------------------------

OverscanRoutine



skipscore
	lda #2
	sta WSYNC
	sta VBLANK	;turn on VBLANK


	


;-------------------------------------------------------------------------
;----------------------------End Main Routines----------------------------
;-------------------------------------------------------------------------


;*************************************************************************

;-------------------------------------------------------------------------
;----------------------Begin Subroutines----------------------------------
;-------------------------------------------------------------------------




KernelCleanupSubroutine

	ldx #4
AdjustYValuesDownLoop
	lda NewSpriteY,X
	sec
	sbc #2
	sta NewSpriteY,X
	dex
	bpl AdjustYValuesDownLoop


 RETURN
	;rts

SetupP1Subroutine
; flickersort algorithm
; count 4-0
; table2=table1 (?)
; detect overlap of sprites in table 2
; if overlap, do regular sort in table2, then place one sprite at top of table 1, decrement # displayed
; if no overlap, do regular sort in table 2 and table 1
fsstart
 ldx #255
copytable
 inx
 lda spritesort,x
 sta SpriteGfxIndex,x
 cpx #4
 bne copytable

 stx temp3 ; highest displayed sprite
 dex
 stx temp2
sortloop
 ldx temp2
 lda spritesort,x
 tax
 lda NewSpriteY,x
 sta temp1

 ldx temp2
 lda spritesort+1,x
 tax
 lda NewSpriteY,x
 sec
 clc
 sbc temp1
 bcc largerXislower

; larger x is higher (A>=temp1)
 cmp spriteheight,x
 bcs countdown
; overlap with x+1>x
; 
; stick x at end of gfxtable, dec counter
overlapping
 dec temp3
 ldx temp2
; inx
 jsr shiftnumbers
 jmp skipswapGfxtable

largerXislower ; (temp1>A)
 tay
 ldx temp2
 lda spritesort,x
 tax
 tya
 eor #$FF
 sbc #1
 bcc overlapping
 cmp spriteheight,x
 bcs notoverlapping

 dec temp3
 ldx temp2
; inx
 jsr shiftnumbers
 jmp skipswapGfxtable 
notoverlapping
; ldx temp2 ; swap display table
; ldy SpriteGfxIndex+1,x
; lda SpriteGfxIndex,x
; sty SpriteGfxIndex,x
; sta SpriteGfxIndex+1,x 

skipswapGfxtable
 ldx temp2 ; swap sort table
 ldy spritesort+1,x
 lda spritesort,x
 sty spritesort,x
 sta spritesort+1,x 

countdown
 dec temp2
 bpl sortloop

checktoohigh
 ldx temp3
 lda SpriteGfxIndex,x
 tax
 lda NewSpriteY,x
 ifconst screenheight
 cmp #screenheight-3
 else
 cmp #$55
 endif
 bcc nonetoohigh
 dec temp3
 bne checktoohigh

nonetoohigh
 rts


shiftnumbers
 ; stick current x at end, shift others down
 ; if x=4: don't do anything
 ; if x=3: swap 3 and 4
 ; if x=2: 2=3, 3=4, 4=2
 ; if x=1: 1=2, 2=3, 3=4, 4=1
 ; if x=0: 0=1, 1=2, 2=3, 3=4, 4=0
; ldy SpriteGfxIndex,x
swaploop
 cpx #4
 beq shiftdone 
 lda SpriteGfxIndex+1,x
 sta SpriteGfxIndex,x
 inx
 jmp swaploop
shiftdone
; sty SpriteGfxIndex,x
 rts

 ifconst debugscore
debugcycles
   ldx #14
   lda INTIM ; display # cycles left in the score

 ifconst mincycles
 lda mincycles 
 cmp INTIM
 lda mincycles
 bcc nochange
 lda INTIM
 sta mincycles
nochange
 endif

;   cmp #$2B
;   bcs no_cycles_left
   bmi cycles_left
   ldx #64
   eor #$ff ;make negative
cycles_left
   stx scorecolor
   and #$7f ; clear sign bit
   tax
   lda scorebcd,x
   sta score+2
   lda scorebcd1,x
   sta score+1
   rts
scorebcd
 .byte $00, $64, $28, $92, $56, $20, $84, $48, $12, $76, $40
 .byte $04, $68, $32, $96, $60, $24, $88, $52, $16, $80, $44
 .byte $08, $72, $36, $00, $64, $28, $92, $56, $20, $84, $48
 .byte $12, $76, $40, $04, $68, $32, $96, $60, $24, $88
scorebcd1
 .byte 0, 0, 1, 1, 2, 3, 3, 4, 5, 5, 6
 .byte 7, 7, 8, 8, 9, $10, $10, $11, $12, $12, $13
 .byte $14, $14, $15, $16, $16, $17, $17, $18, $19, $19, $20
 .byte $21, $21, $22, $23, $23, $24, $24, $25, $26, $26
 endif
; Provided under the CC0 license. See the included LICENSE.txt for details.

start
 sei
 cld
 ldy #0
 lda $D0
 cmp #$2C               ;check RAM location #1
 bne MachineIs2600
 lda $D1
 cmp #$A9               ;check RAM location #2
 bne MachineIs2600
 dey
MachineIs2600
 ldx #0
 txa
clearmem
 inx
 txs
 pha
 bne clearmem
 sty temp1
 ifnconst multisprite
 ifconst pfrowheight
 lda #pfrowheight
 else
 ifconst pfres
 lda #(96/pfres)
 else
 lda #8
 endif
 endif
 sta playfieldpos
 endif
 ldx #5
initscore
 lda #<scoretable
 sta scorepointers,x 
 dex
 bpl initscore
 lda #1
 sta CTRLPF
 ora INTIM
 sta rand

 ifconst multisprite
   jsr multisprite_setup
 endif

 ifnconst bankswitch
   jmp game
 else
   lda #>(game-1)
   pha
   lda #<(game-1)
   pha
   pha
   pha
   ldx #1
   jmp BS_jsr
 endif
; Provided under the CC0 license. See the included LICENSE.txt for details.

;standard routines needed for pretty much all games
; just the random number generator is left - maybe we should remove this asm file altogether?
; repositioning code and score pointer setup moved to overscan
; read switches, joysticks now compiler generated (more efficient)

randomize
	lda rand
	lsr
 ifconst rand16
	rol rand16
 endif
	bcc noeor
	eor #$B4
noeor
	sta rand
 ifconst rand16
	eor rand16
 endif
	RETURN
;bB.asm
; bB.asm file is split here
 if (<*) > (<(*+8))
	repeat ($100-<*)
	.byte 0
	repend
	endif
 if (<*) < 90
	repeat (90-<*)
	.byte 0
	repend
	endif
player2then_0
	.byte 0
	.byte  %00000000
	.byte  %10000010
	.byte  %01000100
	.byte  %11111110
	.byte  %11111110
	.byte  %10111010
	.byte  %01111100
	.byte  %10000010
 if (<*) > (<(*+8))
	repeat ($100-<*)
	.byte 0
	repend
	endif
 if (<*) < 90
	repeat (90-<*)
	.byte 0
	repend
	endif
player4then_0
	.byte 0
	.byte  %00000000
	.byte  %00101000
	.byte  %01000100
	.byte  %11111110
	.byte  %11111110
	.byte  %10111010
	.byte  %01111100
	.byte  %01000100
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
 if (<*) < 90
	repeat (90-<*)
	.byte 0
	repend
	endif
playerL042_2
	.byte  %00000000
	.byte  %00000000
	.byte  %00010000
	.byte  %00100000
	.byte  %00010000
	.byte  %00001000
	.byte  %00010000
	.byte  %00000000
 if (<*) > (<(*+8))
	repeat ($100-<*)
	.byte 0
	repend
	endif
 if (<*) < 90
	repeat (90-<*)
	.byte 0
	repend
	endif
player33then_0
	.byte 0
	.byte  %00000000
	.byte  %10010010
	.byte  %01010100
	.byte  %00000000
	.byte  %11010110
	.byte  %00000000
	.byte  %01010100
	.byte  %10010010
 if (<*) > (<(*+8))
	repeat ($100-<*)
	.byte 0
	repend
	endif
 if (<*) < 90
	repeat (90-<*)
	.byte 0
	repend
	endif
playerL056_0
	.byte 0
	.byte  %00000000
	.byte  %10000010
	.byte  %01000100
	.byte  %11111110
	.byte  %11111110
	.byte  %10111010
	.byte  %01111100
	.byte  %10000010
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
 if (<*) < 90
	repeat (90-<*)
	.byte 0
	repend
	endif
playerL059_1
	.byte  %11111110
	.byte  %11111110
	.byte  %01111100
	.byte  %00010000
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
 if (<*) < 90
	repeat (90-<*)
	.byte 0
	repend
	endif
playerL065_3
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
	.byte  %00010000
	.byte  %00010000
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
 if (<*) > (<(*+24))
	repeat ($100-<*)
	.byte 0
	repend
	endif
 if (<*) < 90
	repeat (90-<*)
	.byte 0
	repend
	endif
playerL073_2
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
	.byte  %11111000
	.byte  %10000000
	.byte  %11000000
	.byte  %10000000
	.byte  %11111000
	.byte  %00000000
	.byte  %10001000
	.byte  %10001000
	.byte  %10101000
	.byte  %11111000
	.byte  %00000000
	.byte  %10001000
	.byte  %11111000
	.byte  %10001000
	.byte  %11111000
	.byte  %00000000
	.byte  %11111000
	.byte  %10001000
	.byte  %10000000
	.byte  %11111000
 if (<*) > (<(*+24))
	repeat ($100-<*)
	.byte 0
	repend
	endif
 if (<*) < 90
	repeat (90-<*)
	.byte 0
	repend
	endif
playerL074_3
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
	.byte  %10001000
	.byte  %11110000
	.byte  %10001000
	.byte  %11111000
	.byte  %00000000
	.byte  %11111000
	.byte  %10000000
	.byte  %11000000
	.byte  %10000000
	.byte  %11111000
	.byte  %00000000
	.byte  %00100000
	.byte  %01010000
	.byte  %10001000
	.byte  %10001000
	.byte  %00000000
	.byte  %11111000
	.byte  %10001000
	.byte  %10001000
	.byte  %11111000
 if ECHOFIRST
       echo "    ",[(scoretable - *)]d , "bytes of ROM space left in bank 2")
 endif 
ECHOFIRST = 1
 
 
; Provided under the CC0 license. See the included LICENSE.txt for details.

; feel free to modify the score graphics - just keep each digit 8 high
; and keep the conditional compilation stuff intact
 ifconst ROM2k
   ORG $F7AC-8
 else
   ifconst bankswitch
     if bankswitch == 8
       ORG $2F94-bscode_length
       RORG $FF94-bscode_length
     endif
     if bankswitch == 16
       ORG $4F94-bscode_length
       RORG $FF94-bscode_length
     endif
     if bankswitch == 32
       ORG $8F94-bscode_length
       RORG $FF94-bscode_length
     endif
     if bankswitch == 64
       ORG  $10F80-bscode_length
       RORG $1FF80-bscode_length
     endif
   else
     ORG $FF9C
   endif
 endif

; font equates
.21stcentury = 1
alarmclock = 2     
handwritten = 3    
interrupted = 4    
retroputer = 5    
whimsey = 6
tiny = 7
hex = 8

 ifconst font
   if font == hex
     ORG . - 48
   endif
 endif

scoretable

 ifconst font
  if font == .21stcentury
    include "score_graphics.asm.21stcentury"
  endif
  if font == alarmclock
    include "score_graphics.asm.alarmclock"
  endif
  if font == handwritten
    include "score_graphics.asm.handwritten"
  endif
  if font == interrupted
    include "score_graphics.asm.interrupted"
  endif
  if font == retroputer
    include "score_graphics.asm.retroputer"
  endif
  if font == whimsey
    include "score_graphics.asm.whimsey"
  endif
  if font == tiny
    include "score_graphics.asm.tiny"
  endif
  if font == hex
    include "score_graphics.asm.hex"
  endif
 else ; default font

       .byte %00111100
       .byte %01100110
       .byte %01100110
       .byte %01100110
       .byte %01100110
       .byte %01100110
       .byte %01100110
       .byte %00111100

       .byte %01111110
       .byte %00011000
       .byte %00011000
       .byte %00011000
       .byte %00011000
       .byte %00111000
       .byte %00011000
       .byte %00001000

       .byte %01111110
       .byte %01100000
       .byte %01100000
       .byte %00111100
       .byte %00000110
       .byte %00000110
       .byte %01000110
       .byte %00111100

       .byte %00111100
       .byte %01000110
       .byte %00000110
       .byte %00000110
       .byte %00011100
       .byte %00000110
       .byte %01000110
       .byte %00111100

       .byte %00001100
       .byte %00001100
       .byte %01111110
       .byte %01001100
       .byte %01001100
       .byte %00101100
       .byte %00011100
       .byte %00001100

       .byte %00111100
       .byte %01000110
       .byte %00000110
       .byte %00000110
       .byte %00111100
       .byte %01100000
       .byte %01100000
       .byte %01111110

       .byte %00111100
       .byte %01100110
       .byte %01100110
       .byte %01100110
       .byte %01111100
       .byte %01100000
       .byte %01100010
       .byte %00111100

       .byte %00110000
       .byte %00110000
       .byte %00110000
       .byte %00011000
       .byte %00001100
       .byte %00000110
       .byte %01000010
       .byte %00111110

       .byte %00111100
       .byte %01100110
       .byte %01100110
       .byte %01100110
       .byte %00111100
       .byte %01100110
       .byte %01100110
       .byte %00111100

       .byte %00111100
       .byte %01000110
       .byte %00000110
       .byte %00111110
       .byte %01100110
       .byte %01100110
       .byte %01100110
       .byte %00111100 

       ifnconst DPC_kernel_options
 
         .byte %00000000
         .byte %00000000
         .byte %00000000
         .byte %00000000
         .byte %00000000
         .byte %00000000
         .byte %00000000
         .byte %00000000 

       endif

 endif

 ifconst ROM2k
   ORG $F7FC
 else
   ifconst bankswitch
     if bankswitch == 8
       ORG $2FF4-bscode_length
       RORG $FFF4-bscode_length
     endif
     if bankswitch == 16
       ORG $4FF4-bscode_length
       RORG $FFF4-bscode_length
     endif
     if bankswitch == 32
       ORG $8FF4-bscode_length
       RORG $FFF4-bscode_length
     endif
     if bankswitch == 64
       ORG  $10FE0-bscode_length
       RORG $1FFE0-bscode_length
     endif
   else
     ORG $FFFC
   endif
 endif
; Provided under the CC0 license. See the included LICENSE.txt for details.

; every bank has this stuff at the same place
; this code can switch to/from any bank at any entry point
; and can preserve register values
; note: lines not starting with a space are not placed in all banks
;
; line below tells the compiler how long this is - do not remove
;size=32

begin_bscode
 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif 
 txs
 if bankswitch == 64
   lda #(((>(start-1)) & $0F) | $F0)
 else
   lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha

BS_return
 pha
 txa
 pha
 tsx

 if bankswitch != 64
   lda 4,x ; get high byte of return address

   rol
   rol
   rol
   rol
   and #bs_mask ;1 3 or 7 for F8/F6/F4
   tax
   inx
 else
   lda 4,x ; get high byte of return address
   tay
   ora #$10 ; change our bank nibble into a valid rom mirror
   sta 4,x
   tya
   lsr 
   lsr 
   lsr 
   lsr 
   tax
   inx
 endif

BS_jsr
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
   echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
   echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
; Provided under the CC0 license. See the included LICENSE.txt for details.

 ifconst bankswitch
   if bankswitch == 8
     ORG $2FFC
     RORG $FFFC
   endif
   if bankswitch == 16
     ORG $4FFC
     RORG $FFFC
   endif
   if bankswitch == 32
     ORG $8FFC
     RORG $FFFC
   endif
   if bankswitch == 64
     ORG  $10FF0
     RORG $1FFF0
     lda $ffe0 ; we use wasted space to assist stella with EF format auto-detection
     ORG  $10FF8
     RORG $1FFF8
     ifconst superchip 
       .byte "E","F","S","C"
     else
       .byte "E","F","E","F"
     endif
     ORG  $10FFC
     RORG $1FFFC
   endif
 else
   ifconst ROM2k
     ORG $F7FC
   else
     ORG $FFFC
   endif
 endif
 .word (start & $ffff)
 .word (start & $ffff)
