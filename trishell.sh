#!/bin/bash

function ajout(){
    #Fonctions permettant d'operer sur notre liste
    list=$list' '$1
}

function taille_de(){
    #Fonction retournant la taille de la liste passee en parametre
    return $#
}

function afficher(){
    #Fonction permettant d'afficher la liste passee en parametre
    echo -e ""
    echo `pwd`:
    for i in $@
        do
        echo -ne "$i\t"
        done
    echo ""
}

function suppression(){
    #Premier parametre = elem a supp, second parametre = list a manipuler
    tmp=''
    for e in $@
        do
        if (test $e != $1);then  tmp=$tmp' '$e; fi
        done
    list=$tmp
}

function inverser_ordre(){
    #Permet d'inverser la liste d'elements
    tmp=''
    for e in $@
        do
        tmp=$e' '$tmp
        done
    list=$tmp
}

function new_list(){
    #Permet de creer une nouvelle liste et de gerer les options
    #Il faudra passer en parametre les options passer lors de l'appel de la commande
    list=*
    for e in $@
        do
        if [ "$e" = "-d" ]
            then
            inverser_ordre $list
        fi
    done
}

#Ajout des elements a afficher dans la liste
new_list $@

#Voici la fonction principal
afficher $list
if [ "$1" = "-R" ]
then
    for i in *
    do
        if [ -d "$i" ]
        then
            cd $i
            new_list $@ #On appel new_list afin de recuperer les fichiers du nouveau repertoie
            afficher $list
            cd ..
        fi
    done
fi

