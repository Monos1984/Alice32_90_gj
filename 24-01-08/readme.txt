Rectification de l’endroit ou on mémorise les caractères personnalisés.
On va garder le screen memory dans la page 0.
Elle prend à ce que j’ai compris 3 pages.
Donc on va envoyer nos caractères dans la 4em page. (3em pages car en programmation est fréquent de débuter par 0 !!! )

Pour gérer le pointeur de la page screen memory c’est le sous registre ROR.
On va le laisser à la page 0 sur les bits du poids fort et il y a une autre donnée sur ROR dont à l’heure actuel j’ai pas regardé mais qui est  8 de base donc pour info voici le morceau de code pour changer ROR.

  ldaa #8
  staa DATA_R1

  ldaa #%10000111
  staa REGISTRE_EXEC


maintenant il faut modifier le pointeur de page pour les caractères utilisateur. C’est le registre DOR et la sous catégorie G0.
On va le configurer à 3 (donc 4em page pour notre exemple)

 ldaa #3
  staa DATA_R1

  ldaa #%10000100
  staa REGISTRE_EXEC

note : Les pointeurs pour les autres types de caractères sont à la page 0, on a seulement modifié les caractères utilisateur !

Retour sur la mémorisation des caractères utilisateur en Vram.
Pour envoyer a la bonne page nos donné , pour être lu il faut activer les 2 bits du poids fort du registre R5.

Un petit Oraa #%11000000  avant envoyer ça dans le Registre R5 semble faire l’affaire.
Morceau de code :

; Octet du tampon
 ldaa BUFFER_P0
 oraa #%11000000
 staa ADRESSE_R5 ; octet du tampon

Pour le moment mon test sembe fonctionner MAIS des test poussés doivent être effectué.

Note soucie dans les couleurs ?
