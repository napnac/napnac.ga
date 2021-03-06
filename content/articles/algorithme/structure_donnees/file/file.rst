Introduction
------------

Comment un centre d'appel arrive-t-il à gérer un surplus de clients ?
Imaginons que tous les opérateurs téléphoniques du centre sont
actuellement occupés et que 42 autres clients appellent dans la minute
qui suit. Comment savoir quel client prendre en premier une fois un
opérateur libre ? Comment faire pour garder un ordre logique si un
client raccroche finalement, ou si d'autres appellent à leur tour ? Il
nous faut donc une structure de données souple, permettant de résoudre
nos problèmes de file d'attente, et cette structure s'appelle justement
: la file.

Principe de la file
-------------------

Une file (*queue* en anglais) est une structure de données de type
**FIFO** (**F**\ irst **I**\ n **F**\ irst **O**\ ut, *premier entré
premier sorti*). Elle fonctionne exactement comme une file d’attente
dans un magasin :

-  Le premier client arrivé dans la file sera le premier servi.
-  Le dernier client arrivé sera le dernier servi.

Voici comment on pourrait représenter une file :

.. figure:: /img/algo/structure/file/exemple_file.png
   :alt: Exemple de représentation d'une file

   Exemple de représentation d'une file

L’action d’ajouter un élément dans la file est appelée : **enfiler** (ou
*enqueue* en anglais) :

.. figure:: /img/algo/structure/file/exemple_ajout.png
   :alt: Un nouvel élément est enfilé

   Un nouvel élément est enfilé

L’action d’enlever un élément de la file est appelée : **défiler** (ou
*dequeue* en anglais) :

.. figure:: /img/algo/structure/file/exemple_suppression.png
   :alt: Un élément est défilé

   Un élément est défilé

Comme la fin de la file est située "à gauche", notre premier élément
pointera vers ``NULL`` pour indiquer le début de la file (et non la fin
comme pour une `liste chaînée </algo/structure/liste_chainee.html>`__,
ou une `pile </algo/structure/pile.html>`__).

Pour représenter une file, on peut utiliser une `liste
chaînée </algo/structure/liste_chainee.html>`__ car les tableaux ne sont
pas du tout adaptés à ce genre de structure de données (soit on gaspille
de la mémoire, soit on réalise plus d'opérations que nécessaires).
Cependant, on peut encore améliorer l'implémentation de notre file, en
utilisant une `liste doublement
chaînée </algo/structure/liste_chainee.html#liste-doublement-chainee>`__.
En effet, si l'on utilise une liste simplement chaînée, il faut
parcourir la liste pour défiler un élément, alors qu'avec une liste
doublement chaînée et deux pointeurs (un vers le début et un vers la
fin), on peut enfiler et défiler en temps constant.

Quelques fonctions pour manipuler une file
------------------------------------------

Des fonctions de base sont nécessaires afin de bien manipuler une file.

.. code:: nohighlight

   créerFile :
      Initialiser les pointeurs de début et de fin à NULL
   supprimerFile :
      Pour chaque élément de la file
         Supprimer l'élément actuel

   enfiler (élément) :
      Faire pointer l'élément suivant du nouvel élément vers la fin
      Faire pointer l'élément précédent du nouvel élément vers NULL
      Mettre à jour le pointeur de fin
   défiler :
      Sauvegarder les données de l'élément en début de file
      Supprimer cet élément
      Faire pointer l'élément suivant du nouveau premier élément vers NULL 
      Mettre à jour le pointeur de début
      Retourner les données sauvegardées

   estVide :
      Si les deux pointeurs de début et de fin pointent vers NULL
         Retourner vrai
      Sinon
         Retourner faux

Complexité
----------

Soit :math:`N` le nombre d'éléments de la file.

-  ``créerFile`` : :math:`O(1)`
-  ``supprimerFile`` : :math:`O(N)`
-  ``enfiler`` : :math:`O(1)`
-  ``défiler`` : :math:`O(1)`
-  ``estVide`` : :math:`O(1)`

Implémentation
--------------

Une implémentation en C d’une file :

[[secret="file.c"]]

.. code:: c

   #include <stdio.h>
   #include <stdlib.h>

   typedef struct Noeud Noeud;
   struct Noeud 
   {
      int donnee;
      Noeud *suivant;
      Noeud *precedent;
   };

   typedef struct File File;
   struct File
   {
      Noeud *debut;
      Noeud *fin;
   };

   int estVide(File *file);

   void creerFile(File *file)
   {
      file->debut = NULL;
      file->fin = NULL;
   }

   void supprimerFile(File *file)
   {
      Noeud *iFile;

      for(iFile = file->fin; iFile != NULL; ) {
         Noeud *temp;

         temp = iFile->suivant;
         free(iFile);
         iFile = temp;
      }
   }

   void enfiler(File *file, int donnee)
   {
      Noeud *nouveau;

      nouveau = malloc(sizeof(Noeud));
      nouveau->suivant = file->fin;
      nouveau->precedent = NULL;
      nouveau->donnee = donnee;

      if(estVide(file)) {
         file->debut = file->fin = nouveau;
         return;
      }
      else {
         file->fin->precedent = nouveau;
         file->fin = nouveau;
      }
   }

   int defiler(File *file)
   {
      Noeud *temp;
      int donnee;

      temp = file->debut->precedent;
      donnee = file->debut->donnee;
      free(file->debut);
      file->debut = temp;
      file->debut->suivant = NULL;

      return donnee;
   }

   int estVide(File *file)
   {
      if(file->debut == NULL && file->fin == NULL)
         return 1;
      else
         return 0;
   }

   int main(void)
   {
      File file;

      creerFile(&file);

      enfiler(&file, 42);
      // 42
      enfiler(&file, 9);
      // 9 42

      int retour = defiler(&file);
      // retour = 42

      supprimerFile(&file);

      return 0;
   }

[[/secret]]

STL
~~~

Si vous programmez en C++, la
`STL <https://en.wikipedia.org/wiki/Standard_Template_Library>`__
(*Standard Template Library*) fournit une implémentation et des
fonctions permettant de manipuler une file :
http://www.cplusplus.com/reference/queue/queue/

File à priorité
---------------

Une file à priorité (*priority queue* en anglais), est sans doute la
variante de la file la plus utilisée. On la retrouve notamment dans
l'\ `algorithme de
Dijkstra </algo/structure/graphe/plus_court_chemin/dijkstra.html>`__
pour trouver le plus court chemin entre deux nœuds d'un
`graphe </algo/structure/graphe.html>`__ pondéré positivement. Chaque
élément se voit attribuer une **clé**, permettant d'organiser la file
(d'où le nom de file à **priorité**). On peut ensuite rapidement
récupérer l'élément avec la priorité la plus élevée.

On implémente une file à priorité grâce à un
`tas </algo/structure/arbre/tas.html>`__ (max ou min en fonction des
besoins), et si vous programmez en C++ la STL fournit aussi une
implémentation :
http://www.cplusplus.com/reference/queue/priority_queue/.

Notez qu'il ne faut pas confondre file à priorité et tas. En effet, même
si les deux notions semblent exactement pareil en pratique, en théorie
une file à priorité est un type de donnée **abstrait**, alors que le tas
est une structure de données **réelle** et **concrète**.

Conclusion
----------

La file permet donc d'implémenter un comportement de file d'attente, qui
est pratique dans de nombreuses situations :

-  Quand votre ordinateur doit gérer plusieurs tâches à la fois, une
   file s'avère très utile pour stocker les opérations afin de les
   traiter par ordre d'arrivée ensuite. Il peut aussi implémenter une
   file à priorité afin d'exécuter les tâches importantes voir urgentes
   en premier.
-  Si un serveur est débordé par les requêtes, une file sera adaptée
   pour renvoyer l'information aux personnes dans l'ordre d'arrivée pour
   ne pas faire attendre trop longtemps le client.
-  De même si un centre d'appel est occupé, les clients seront pris en
   charge (par un opérateur qui vient de se libérer) grâce à une file en
   fonction de l'ordre d'arrivée (premier arrivé, premier servi).
