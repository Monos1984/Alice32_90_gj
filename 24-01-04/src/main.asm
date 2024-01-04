; **********************************************************
; * Game Jams Retro Programmers United for Obscure Systems *
; *                       Alice 32-90                      *
; * ------------------------------------------------------ *
; * VBCC : Assembleur 6803                                 *
; **********************************************************

;  Code source du 04/01/2024


; Controleur video EF9345 
; 8 Registres
; R0 : $BF20 Commande / Status registre
; R1,R2,R3 : Data
; R4,R5,R6,R7 : Adresse VRAM 
; ROR, DOR : Base address of displayed page memory and used external character generators.
; PAT, MAT, TGS : Used to select the page attributes and format, and to program the timing generator option.


GET_KEYBOARD = $F883 ; retourne Valeur ASCII du clavier dans A

COMMANDE_R0 = $BF20 ; 48928
DATA_R1     = $BF21 ; 48939
DATA_R2     = $BF22 ; 48930
DATA_R3     = $BF23 ; 48931
ADRESSE_R4  = $BF24 ; 48932
ADRESSE_R5  = $BF25 ; 48933
ADRESSE_R6  = $BF26 ; 48934
ADRESSE_R7  = $BF27 ; 48935
REGISTRE_ROR = $BF28 ; Pas sur que cela soit cette adresse et que ça soit un ROR

; *** A Verifier ***
REGISTRE_DOR = $BF29
REGISTRE_PAT = $BF2A
REGISTRE_MAT = $BF2B
REGISTRE_TGC = $BF2C


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
;  ldaa #2 ; (2 = 32 col, 1 = 40 col, 0 = 80 col)
  ;staa $301A
 ; JSR $D42C
 
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

  ; --------------------------------------
  ; * programmation de la puce graphique *
  ; --------------------------------------
 
  ; - lettre Ascii -
  ;0 et 128
  ldaa #$41
  staa DATA_R1
  
  ; - Affichage en lettre -
  ldaa #%00000001
  staa DATA_R2
  
  ; - Couleur -
  ;      %iBVRcbvr
  ; i....: Inversion couleur
  ; BVR..: Couleur de la forme
  ; c....:Clinotement
  ; bvr..:Couleur du fond
  
  ldaa #%01111100
  staa DATA_R3
  
  
  ; - Ligne -
  ; 0/1 après ça passe à 8 !!!
  
  ldaa #10
  staa ADRESSE_R6
  
  ; - Colonne -
  ldaa #0
  staa ADRESSE_R7
  
  ; - Lancement -
  ; "Pas sur que ça soit le registre Ror !!!"
  ldaa #1
  staa REGISTRE_ROR
  
   
  jmp BC_MAIN