Introduction
------------

Prenons l'exemple d'une fonction dans un programme. Cette fonction peut
appeler d'autres fonctions qui à leurs tours appellent d'autres
fonctions (qui elles même appellent des fonctions, etc.). Comment savoir
et se souvenir de l'ordre d'appels, de qui appelle qui, et où retourner
une fois la fonction appelée terminée ? Une première réponse pourrait
être de stocker toutes ces informations dans un simple tableau, mais
comment le parcourir ? Où insérer les nouvelles données ? Comment
enlever les éléments inutiles (lorsqu'une fonction a finie d'être
exécutée) ?

Toutes ces questions nous amènent à penser qu'il nous faut une structure
de données organisée, bien définie et qui puisse gérer cette idée
d'imbrication : la pile.

Principe de la pile
-------------------

Une pile (*stack* en anglais) est une structure de données de type
**LIFO** (**L**\ ast **I**\ n **F**\ irst **O**\ ut, *dernier arrivé
premier sorti*). Elle fonctionne exactement comme une pile d’assiettes :

-  Quand on ajoute une assiette sur la pile on l’ajoute en haut.
-  Quand on enlève une assiette on enlève celle du haut pour ne pas
   faire tomber le reste.

C’est le principe LIFO, lorsqu’on ajoute un élément sur une pile il est
en haut, et lorsqu’on retire un élément on prend le dernier ajouté
(celui tout en haut).

.. figure:: /img/algo/structure/pile/exemple_pile.png
   :alt: Exemple de représentation d'une pile

   Exemple de représentation d'une pile

L’action d’ajouter un élément dans la pile est appelée : **empiler** (ou
*push* en anglais) :

.. figure:: /img/algo/structure/pile/exemple_ajout.png
   :alt: Un nouvel élément est empilé

   Un nouvel élément est empilé

L’action d’enlever un élément de la pile est appelée : **dépiler** (ou
*pop* en anglais) :

.. figure:: /img/algo/structure/pile/exemple_suppression.png
   :alt: Un élément est dépilé

   Un élément est dépilé

Pour représenter une pile, je vais vous présenter deux moyens :

-  Avec une `liste chaînée </algo/structure/liste_chainee.html>`__.
-  Avec un tableau ainsi qu’un indice nous indiquant le prochain élément
   libre dans la pile. Cet indice est appelé pointeur de pile (ou *stack
   pointer* en anglais, souvent abrégé *SP*).

Quelques fonctions pour manipuler une pile
------------------------------------------

Comme pour une liste chaînée, il existe différentes fonctions de bases
permettant de manipuler une pile.

Avec une liste chaînée
~~~~~~~~~~~~~~~~~~~~~~

.. code:: nohighlight

   créerPile :
      Initialiser la pile à NULL
   supprimerPile :
      Pour chaque élément de la pile
         Supprimer l'élément actuel

   empiler (élément) :
      Faire pointer le haut de la pile vers le nouvel élément
   dépiler :
      Sauvegarder les données de l'élément en haut de la pile
      Supprimer l'élément en haut
      Faire pointer le haut de la pile vers NULL
      Retourner les données sauvegardées

   estVide :
      Si le premier élément de la pile est NULL
         Retourner vrai
      Sinon
         Retourner faux

Avec un tableau
~~~~~~~~~~~~~~~

.. code:: nohighlight

   créerPile :
      Créer un tableau d'une taille fixe et suffisamment grand pour la pile
      Initialiser le pointeur de pile (PP) à 0
   supprimerPile :
      Supprimer le tableau

   empiler (élément) :
      Affecter les données du nouvel élément à la case d'index PP du tableau
      Incrémenter le PP
   dépiler :
      Décrémenter le PP
      Retourner les données de l'élément d'index PP du tableau

   estVide :
      Si PP = 0
         Retourner vrai
      Sinon 
         Retourner faux

Complexité
----------

Soit :math:`N` le nombre d'éléments de la pile.

-  ``créerPile`` : :math:`O(1)`
-  ``supprimerPile`` : :math:`O(N)`
-  ``empiler`` : :math:`O(1)`
-  ``dépiler`` : :math:`O(1)`
-  ``estVide`` : :math:`O(1)`

Implémentation
--------------

Liste chaînée
~~~~~~~~~~~~~

[[secret="pile_liste_chainee.c"]]

.. code:: c

   #include <stdio.h>
   #include <stdlib.h>

   typedef struct Noeud Noeud;
   struct Noeud
   {
      Noeud *suivant;
      int donnee;
   };

   typedef Noeud *Pile;

   void creerPile(Pile *pile)
   {
      *pile = NULL;
   }

   void supprimerPile(Pile *pile)
   {
      Noeud *iPile;

      for(iPile = *pile; iPile != NULL; ) {
         Noeud *temp;

         temp = iPile->suivant;
         free(iPile);
         iPile = temp;
      }
   }

   void empiler(Pile *pile, int donnee)
   {
      Noeud *nouveau;

      nouveau = malloc(sizeof(Noeud));
      nouveau->suivant = *pile;
      nouveau->donnee = donnee;

      *pile = nouveau;
   }

   int depiler(Pile *pile)
   {
      Noeud *temp;
      int donnee;

      temp = (*pile)->suivant;
      donnee = (*pile)->donnee;
      free(*pile);
      *pile = temp;

      return donnee;
   }

   int estVide(Pile *pile)
   {
      if(*pile == NULL)
         return 1;
      else
         return 0;
   }

   int main(void)
   {
      Pile pile;

      creerPile(&pile);

      empiler(&pile, 42);
      // 42
      empiler(&pile, 9);
      // 9
      // 42

      int retour = depiler(&pile);
      // retour = 9

      supprimerPile(&pile);

      return 0;
   }

Le code est simple et ne nécessite pas d’explication, si besoin je vous
invite à relire l'article sur les `listes
chaînées </algo/structure/liste_chainee.html>`__ pour bien comprendre le
code.

[[/secret]]

Tableau
~~~~~~~

[[secret="pile_tableau.c"]]

.. code:: c

   #include <stdio.h>

   #define TAILLE_MAX 256

   int pile[TAILLE_MAX];
   int PP;

   void creerPile(void)
   {
      PP = 0;
   }

   void empiler(int donnee)
   {
      pile[PP] = donnee;
      ++PP;
   }

   int depiler(void)
   {
      --PP;
      return pile[PP];
   }

   int estVidePile(void)
   {
      if(PP == 0)
         return 1;
      else
         return 0;
   }

   int main(void)
   {
      creerPile();

      empiler(42);
      // 42
      empiler(9);
      // 9
      // 42

      int retour = depiler();
      // retour = 9

      return 0;
   }

Cette implémentation est facile à comprendre et à utiliser.

[[/secret]]

STL
~~~

Si vous programmez en C++, la
`STL <https://en.wikipedia.org/wiki/Standard_Template_Library>`__
(*Standard Template Library*) fournit une implémentation et des
fonctions permettant de manipuler une pile :
http://www.cplusplus.com/reference/stack/stack/

Conclusion
----------

La pile est donc une structure de données facile à implémenter et peut
être pratique dans de nombreux domaines :

-  Dans un éditeur : quand vous écrivez votre prochain article sur votre
   éditeur préféré, et que vous ne cessez de faire des ctrl+z et ctrl+y
   pour revenir en arrière/avant, vous utilisez en réalité une pile.
   Chaque opération va être empilée pour garder l'ordre dans lequel vous
   les avez réalisées, et vous pouvez ainsi facilement parcourir la pile
   des opérations pour vous retrouver à tel moment précis de votre
   édition.
-  Lors d'un appel de fonction : à chaque fois que vous appelez une
   fonction dans votre programme, la pile d'exécution (ou `pile
   d'appel <https://en.wikipedia.org/wiki/Call_stack>`__) empile les
   informations à propos de l'endroit où vous réalisez l'appel pour se
   souvenir où revenir à la fin de la fonction appelée.
-  Pour évaluer des expressions : dans certains cas, une pile peut être
   utilisée pour évaluer des expressions (mathématiques ou syntaxiques).
   Par exemple, si vous devez évaluer une expression en notation
   polonaise inverse
   (`NPI <https://en.wikipedia.org/wiki/Reverse_Polish_notation>`__),
   une pile est indispensable pour calculer l'expression au fur et à
   mesure des opérations (quand vous rencontrez un nombre vous
   l'empilez, quand vous rencontrez un opérateur vous dépilez les deux
   derniers éléments, et vous empilez le résultat).
-  Plusieurs `machines
   virtuelles <https://en.wikipedia.org/wiki/Virtual_machine>`__ sont
   implémentées sur le principe d'une pile, par exemple celle de Java.
   Si vous voulez en savoir plus à ce sujet, cet article explique très
   bien le principe de machine virtuelle et les différentes
   implémentations possibles :
   https://markfaction.wordpress.com/2012/07/15/stack-based-vs-register-based-virtual-machine-architecture-and-the-dalvik-vm/
