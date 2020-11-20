# Projet "Trier avec SHELL"

Projet réalisé par Charles Kempa, Thibaut Masnin et Thomas Dignoire.

## Description

Script SHELL qui trie les entrées d’un répertoire suivant différents critères.

Afin d'utiliser ce script comme commande, voici la démarche à suivre :

* Mettez vous à l'endroit où se situe trishell.
* Faites : chmod u+x trishell.sh
* Faites : sudo cp trishell.sh /usr/bin

# Liste des fonctionnalités

* Affichage d'un répertoire.
* Option -R (Affichage d'un réprtoire de façon récursive, dont le nom est celui précisé par -R).
* Option -d (Tri la liste du contenu du repertoire à afficher apr ordre decroissant).
* Option -n (Tri la liste du contenu du repertoire à afficher selon le nom des entrées).
* Option -l (Tri la liste du contenu du repertoire à afficher selon le nombre de lignes de chaque fichier).
* Option -e (Tri la liste du contenu du repertoire à afficher selon l'extension des fichiers).
* Option -t (Tri la liste du contenu du repertoire à afficher selon le type de chaque fichier).
* Option -s (Tri la liste du contenu du repertoire à afficher selon la taille de chaque fichier).
* Option -p (Tri la liste du contenu du repertoire à afficher selon le nom de l'utilisateur propriétaire de chaque fichier).
* Option -g (Tri la liste du contenu du repertoire à afficher selon le nom du groupe propriétaire de chaque fichier).
* Option -m (Tri la liste du contenu du repertoire à afficher selon la date de la derniere modification de chaque fichier).

# Liste des fonctions

* afficher(): Permet d'afficher les fichiers dans un repertoire, cette fonction permet aussi de se déplacer dans les répertoires si il le faut. (Si l'option -d est passer en paramétre, c'est ici que l'inversement ce produit).
* inverser_ordre(): Permet d'inverser l'ordre de la chaîne de caractères passée en paramétre, cette fonction correspond à l'option -d.
* arborescence(): Permet de parcourir l'arboresence de fichier de façon récursive, cette fonction correspond à l'option -R.
* swapSideBySide(): Permet d'échanger deux mots côte à côte dans une même chaîne de caractères, elle prend en paramètre la chaîne à modifier, les mots à modifier sont défini dans la fonction qui fait appel à swapSideBySide().
* trie(): Permet de trier une chaîne de caractères, c'est la fonction principal de cette commande. Selon les options passées en paramètre elle le résultat de cette fonction changera. Algorithme de trie utilisé: Trie par sélection.
* comparer(): Permet de comparer 2 éléments côte à côte dans une chaîne de caractères afin de déterminé si il faut les échanger, ceci selon les options passer en paramètre de la commande. Cette fonction vérifie aussi si les options passées en paramètre sont légal ( 't' est autorisé mas pas 'x').

# Répartition des tâches

* Algorithme de trie : Charles.
* -R : Thibaut.
* -d : Thomas.
* -n : Charles.
* -s : Charles.
* -m : Thomas.
* -l : Thomas.
* -e : Thomas.
* -t : Charles.
* -p : Thomas.
* -g : Thomas.

Liens utiles :

* [Trello](https://trello.com/b/2FQoZzJh/projet-shell).
* [gitHub](https://github.com/iDrack/TriShell).


