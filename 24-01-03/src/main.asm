; **********************************************************
; * Game Jams Retro Programmers United for Obscure Systems *
; *                       Alice 32-90                      *
; * ------------------------------------------------------ *
; * VBCC : Assembleur 6803                                 *
; **********************************************************

;  Code source du 03/01/2024


; Controleur video EF9345 
; 8 Registres
; R0 : Commande / Status registre
; R1,R2,R3 : Data
; R4,R5,R6,R7 : Adresse VRAM 
; ROR, DOR : Base address of displayed page memory and used external character generators.
; PAT, MAT, TGS : Used to select the page attributes and format, and to program the timing generator option.


GET_KEYBOARD = $F883 ; retourne Valeur ASCII du clavier dans A

  *= $3346
; ================
; * Basic Header *
; ================

; -----------------
; - 10 exec 13142 -
; -       $3356   -
; -----------------
  .byte $33, $52, $00, $0a, $9f, $20, $31, $33, $31, $34, $32, $00, $00, $00, $00, $00
  
; -----------------  
; * adresse $3356 *
; -----------------
  ;ldaa #69 ; lda a
  
 ;  jsr $D400 ; Initiation du mode 40 col
 
; * Changement de mode *
  ldaa #2 ; (2 = 32 col, 1 = 40 col, 0 = 80 col)
  staa $301A
  JSR $D42C
 
; Note sur le changement mode : Deux trois truc cheloux à comprendre 
 
 
  ; ---------------------
  ; * CLS semigraph²ique *
  ; ---------------------
  ldab #134+48 ; valeur du motif  + valeur de la couleur
  jsr $D406 ; routine cls
  
  ; -----------------------
  ; * Afficher une lettre *
  ; -----------------------
  ldaa #$41  ; Affier un A
  ldx #$0A03 ; Ligne 10,colonne 3
  jsr $d40c  ; Routine affichage
  
  ldaa #$20  ; valeur ascii de la lettre à afficher
  ldx #$0001 ; Ligne/colonne 
  jsr $d40c  ; routine affichage
 
  ldaa #$42  ; valeur ascii de la lettre à afficher
  ldx #$001F ; Ligne/colonne 
  jsr $d40c  ; routine affichage
  
  ldaa #$43  ; valeur ascii de la lettre à afficher
  ldx #$0027 ; Ligne/colonne 
  jsr $d40c  ; routine affichage
  
BC_MAIN
  Jsr GET_KEYBOARD ; A va être modifié
  
  CMPA #$41
  bne END_TEST
  
  ; --------------------------------------------------
  ; * 2em methode pour afficher une lettre à l'ecran *
  ; --------------------------------------------------
  
  ; - init sortie -
  ldaa #0
  staa $E8 ; (Affichage ecran (0); Affichage imprimante (1)
  
  ; - Position X -
  ldaa #15
  staa $3281
  
  ; - Position Y -
  ldaa #10
  staa $3280
  
  ;  - valeur Ascii à afficher -
  ldaa #45 ; Directos dans a
  
  jsr $F9C6 ; routine
  
  
  
END_TEST
  ;ldaa #$69
  ;staa $1f
  
  ldaa #$69
  staa $BF20
  
  
  jmp BC_MAIN