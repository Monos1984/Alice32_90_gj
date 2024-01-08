; **********************************************************
; * Game Jams Retro Programmers United for Obscure Systems *
; *                       Alice 32-90                      *
; * ------------------------------------------------------ *
; * VBCC : Assembleur 6803                                 *
; **********************************************************

;  Code source du 0801/2024




; Controleur video EF9345 
; 8 Registres
; R0 : $BF20 Commande / Status registre
; R1,R2,R3 : Data
; R4,R5,R6,R7 : Adresse VRAM 
; ROR, DOR : Base address of displayed page memory and used external character generators.
; PAT, MAT, TGS : Used to select the page attributes and format, and to program the timing generator option.




GET_KEYBOARD = $F883 ; retourne Valeur ASCII du clavier dans A

COMMANDE_R0 = $BF20 ; 48928
DATA_R1     = $BF21 ; 48929
DATA_R2     = $BF22 ; 48930
DATA_R3     = $BF23 ; 48931
ADRESSE_R4  = $BF24 ; 48932
ADRESSE_R5  = $BF25 ; 48933
ADRESSE_R6  = $BF26 ; 48934
ADRESSE_R7  = $BF27 ; 48935

REGISTRE_EXEC = $BF28 ; 48936 Registre R1 en Execution
; *** A Verifier ***


; Character redefini
; Adresse en R4 et R5
; R1 Motif
; Ro Exectufif 48+4 ?







  *= $3346
; ================
; * Basic Header *
; ================

; -----------------
; - 10 exec 13142 -
; -       $3356   -
; -----------------
  .byte $33, $52, $00, $0a, $9f, $20, $31, $33, $31, $34, $32, $00, $00, $00, $00, $00
  
  
 ; --------------------------
 ; * Memoriser un character *
 ; --------------------------
 ; OCT (R0) %00110p0i
 ; P = 0 alors adresse R6 et R7
 ; P = 1 alors adresse R4 R5
 ; i = pointeur incrementation 
 ; R0 exec = %00110100
 
 ; R1 = Data à envoyer
 ; R4 et R5 Adresse des data à envoyer/



; =====================================
; * Configurer Ror qui est 08 de base *
; =====================================
 ; ldaa #%00101000
  ldaa #8
  staa DATA_R1

  ldaa #%10000111
  staa REGISTRE_EXEC

   jsr BUSY 
   
; =========================================================================   
; * Configuration de Dor pour pointer sur la 4em page pour les font users *   
; =========================================================================
  ldaa #%00100011
  staa DATA_R1

  ldaa #%10000100
  staa REGISTRE_EXEC
  jsr BUSY 
 
 
; ================================================== 
; * Envoyer une image de 32x10px en mémoire page 3 *
; ================================================== 
 
 ldx #DATA_CHARSET ; Charge l'adresse du tableau des donnés du charset.
 ldaa #0
 staa BUFFER_P0
; ---------------------- 
; * Debut de la boucle *
; ----------------------
START_DATA 
 
; Valeur à stocker en Vram 
 lda 0,x
 staa DATA_R1
 
; index du tampon  
 ldaa #0
 staa ADRESSE_R4 ; id du tampon

; Octet du tampon
 ldaa BUFFER_P0
 oraa #%11000000 ; On force les 2 bits du poids fort pour envoyer les datas en page 3
 staa ADRESSE_R5 ; octet du tampon
 
; On execute le transfère.
 ldaa #%00110100
 staa REGISTRE_EXEC
 
; On attend que la puce EF nous autorise à envoyer des datas !!!
 jsr BUSY 
 
; Increment BUFFER_PO et X
 inc BUFFER_P0 
 inx
 
; On test si on est pas à la fin du tampon. (Un Tampon c'est 40 octets)
 ldaa BUFFER_P0 
 cmpa #40
 bne START_DATA 


; ============================
; * Envoyer le map en page 0 *
; ============================ 
  ldx #DATA_LEVEL
  
  ldaa #0
  staa PX
  staa INDEX_BC
  
  ldaa #8
  staa PY
  
DEBUT_AFFICHAGE


  ; Configuration d'affichage
  ldaa #%10000000
  staa DATA_R2
  
  ; %000 Noir
  ; %001 Rouge
  ; %010 Vert
  ; %011 Orange
  ; %100 un bleu Fonce
  ; %101 Mauve Fonce
  ; %110 un Bleu claire
  ; %111 Mauve claire
  ; Attribut 
  ;      IFFFCBBB
  ldaa #%01110000
  staa DATA_R3


  ; Id du tiles 
  ldaa 0,x
  staa DATA_R1
  
  ; Ligne
  ldaa PY
  ; oraa #%10000000
  staa ADRESSE_R6
  
  ; - Colonne -
  ldaa PX
  
  staa ADRESSE_R7
  
  
  
  ; Execution
  ldaa #1
  staa REGISTRE_EXEC

  jsr BUSY 

  inc PX
  ldaa PX
  CMPA #40
  BNE END_PX_INC
  inc PY
  ldaa #0
  staa PX
END_PX_INC

  inx
  inc INDEX_BC
  lda PY
  CMPA #24+8
  BNE DEBUT_AFFICHAGE


; ===============
; * Boucle Main *
; ===============
BC_MAIN
  jmp BC_MAIN
  
  
 ; **************************
 ; *  Busy                  *
 ; **************************
 
BUSY 
  tst COMMANDE_R0
  bmi BUSY
  rts
 
; ************* 
; * Les Datas *
; *************
 
; ====================================== 
; * 1er images de 32x10px soit 4 fonts *
; ======================================
DATA_CHARSET
  .byte %11111111,%11111111,%00000000,%00000000
  .byte %10101011,%10000001,%00111100,%00000000
  .byte %11010101,%10000001,%00100100,%00000000
  .byte %10101011,%10000001,%00111100,%00000000
  .byte %11010101,%10000001,%00000000,%00000000
  .byte %10101011,%10000001,%00000000,%00000000
  .byte %11010101,%10000001,%00000000,%00000000
  .byte %10101011,%10000001,%00000000,%00000000
  .byte %11010101,%10000001,%00000000,%00000000
  .byte %11111111,%11111111,%00000000,%00000000
  
  
; ==================
; * Test de niveau *
; ==================  
DATA_LEVEL
  .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
  .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1


; =====================================
; * Etiquette variable pour les tests *
; =====================================
PX
  .byte 0
PY
  .byte 0
INDEX_BC
  .byte 0
BUFFER_P0
  .byte 0