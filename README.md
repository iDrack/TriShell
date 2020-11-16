# Projet "Trier avec SHELL"

Projet réalisé par Charles Kempa, Thibaut Masnin et Thomas Dignoire.

## Description

Programme qui trie les entrées d’un répertoire suivant différents critères. Ce programme est réalisé en SHELL.
Afin d'utiliser ce script comme commande, voici la démarche à suivre :

* Mettez vous à l'endroit oú se situe trishell
* Faites : chmod u+x trishell
* Faites : sudo cp trishell /usr/bin

## Particularites

Ce script n'utilise pas de liste, nous utilisons une chaine de characteres afin de simuler une liste.
Chaque element de cette "liste" est separee par un espace.
Afin de manipuler cette "liste", il faut utiliser les fonctions suivantes:

* ajout()
* suppression()
* taille_de()
* afficher()

# Répartition des taches

* -R : Thibaut
* -d : Thomas
* -n : Charles
* -s : Charles
* -m : Thomas 
* -l : Thomas
* -e : Thomas
* -t : Charles
* -p : Thomas
* -g : Thomas

[Trello](https://trello.com/b/2FQoZzJh/projet-shell)

# Liste des fonctionnalités

* Affichage d'un répertoire.
* Option -R (Affichage d'un réprtoire, dont le nom est celui précisé par -R).
* Option -d (Tri la liste du contenu du repertoire a afficher apr ordre decroissant).
* Option -n (Tri la liste du contenu du repertoire a afficher selon le nom des entrees)
* Option -l (Tri la liste du contenu du repertoire a afficher selon le nombre de lignes de chaque fichier)
* Option -e (Tri la liste du contenu du repertoire a afficher selon l'extension des fichiers)
* Option -t (Tri la liste du contenu du repertoire a afficher selon le type de chaque fichier)
* Option -s (Tri la liste du contenu du repertoire a afficher selon la taille de chaque ficheir)
* Option -p (Tri la liste du contenu du repertoire a afficher selon le nom de l'utilisateur proprietaire de chaque fichier)
* Option -g (Tri la liste du contenu du repertoire a afficher selon le nom du groupe proprietaire de chaque fichier)
* Option -m (Tri la liste du contenu du repertoire a afficher selon la date de la derniere modification de chaque fichier)
