Une bonne séance de matin.
J’arrive enfin à afficher des fonts personnalisés. Dans l’image que j’ai affiché c’est juste deux fonts qui sont affichés à partir d’un tableau. (En assembleur)

1er étape c’est de dire à la puce EF de pointer sur une des 8 pages disponible de la mémoire vidéo.
On va rester simple, on va placer nos fonts personnalisé en page 0 !!!

Le Registre pour indiquer à la puce EF (Oué je vais la nommé juste EF!), c’est le registre DOR.
C’est les bits du poids faible. Enfin les trois bits car on a que 8ko de Vram et non 16. Donc que 8 page!!!

On va donc lui foutre la valeur 0 à notre DOR.
Pour Dire à notre DOR de prendre la valeur 0, on va  placer la valeur 0 dans notre registre R1 de EF
et utiliser le registre R0 En exécution avec la valeur  #%10000100 , 

En ASM cela fait un truc du genre.

Ldaa  #0
Staa DATA_R1
 
Ldaa #%10000100
staa REGISTRE_EXEC

je replace mes défines ici.
COMMANDE_R0 = $BF20 ; 48928
DATA_R1     = $BF21 ; 48929
DATA_R2     = $BF22 ; 48930
DATA_R3     = $BF23 ; 48931
ADRESSE_R4  = $BF24 ; 48932
ADRESSE_R5  = $BF25 ; 48933
ADRESSE_R6  = $BF26 ; 48934
ADRESSE_R7  = $BF27 ; 48935

REGISTRE_EXEC = $BF28 ; 48936 Registre R1 en Execution

Maintenant on va attaquer de comment envoyer un valeur dans la Vram  !
Bon C’est simple. La valeur à envoyer en Vram sera mémorisé dans le registre DATA_R1

un Ldaa #30
staa DATA_R1

permet d’envoyer #30 en vram.
Maintenant il faut savoir dire ou !!! 

Je redonne l’explication de comment est géré la Vram.
La vram est découpé en 8 pages de 1024 octets.
Dans chaque page, c’est sous découpés en bloc de 40 octets. (EF appelle ça un tampon)
Le tampon permet de mémoriser une image de 32x10 pixel qui est découpé en 4 latéralement pour avoir un caractère (ou font ou tile vous appelez ça comme bon il vous sembles…) de 8x10 pixel.
 
Donc pour envoyer des data on va choisir le numéro du tampon dans le registre R4,
Attention Vous avez le droit au tampon 0 puis après on passe au tampon 8. Il y a un troue.
Et enfin peux choisir l’octet du tampon à modifier avec le registre R5.
Exemple si je veux modifier l’octet 8 du tampon  12 !
R4 = 12
R5 = 8

Et enfin on exécute en balançant la valeur #%00110100 dans le registre R0 d’exectution.
Avec un jeu de boucle, et de data vous pouvez remplir un tampon d’une image de 32x10.

Bon c’est bien beau mais comment afficher ce qu’on a fait à l’écran ?

Alors voici une petite séquence pour afficher une font.

- Il faut indiquer au EF qu’on va utiliser des fonts personnalisés.
On va donc activé le bit 7 dans le registre R2

Ce qui fait :
ldaa #%10000000
staa DATA_R2

Ensuite l’attribut (de dana  je voulais la faire) du font à afficher.
C’est le registre DATA R3
l’encodage est le suivant :

Bit 7 : Inversion des couleurs
Bit 6,5,4 : Couleur des Formes
Bit 3 : Clignotement de la font.
Bit 2,1,0 : Couleurs du font.

Donc 
ldaa #%01110001
staa DATA_R3

Veux dire par inversion vidéo.
Les formes auront la couleur numéro 7 (%111)
Pas de clignotement
La couleur du font aura la couleur numéro 1 (%001)

Ensuite dans le registre R1 on balance le numero de la font personnalisé.
(attention 0,1,2,3 pour les fonts du tampon 0 et calculé bien avec les troues!!!)

En registre R6 c’est la « ligne »  (Attention la aussi il y a le troue ! 0 puis 8 pour la ligne 2)
Et le registre R7 c’est la colonne.

Et on exécute le code avec juste un #1 dans le registre R0 exécution.

Voilou ,,,,,



