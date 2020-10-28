#!/bin/bash

function ajout {
    #Fonctions permettant d'operer sur notre liste
    list=$list' '$1
}

function taille_de {
    #Fonction retournant la taille de la liste passee en parametre
    return $#
}

function afficher {
    #Fonction permettant d'afficher la liste passee en parametre
    for i in $@
    do
        if [ "$i" != "*" ]
	then
	    echo -ne "$i\t"
	fi
    done
    echo ""
}

function suppression {
    #Premier parametre = elem a supp, second parametre = list a manipuler
    tmp=''
    for e in $@
        do
        if (test $e != $1);then  tmp=$tmp' '$e; fi
        done
    list=$tmp
}

function inverser_ordre {
    #Permet d inverser la liste d elements
    tmp=''
    for e in $@
        do
        tmp=$e' '$tmp
        done
    list=$tmp
}

function new_list {
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


function arborescence {
    dossiers=''
    echo -e "\n$1:"
    for i in *
    do
	if [ "$i" != "*" ]
        then
            echo -ne "$i\t"
            if [ -d "$i" ]
            then
		dossiers=$dossiers' '$i
	    fi
        fi
    done
    echo ""
    for j in $dossiers
    do
	cd $j
	arborescence "$1/$j"
	cd ..
    done
}



#Ajout des elements a afficher dans la liste
new_list $@

#Voici la fonction principal
if [ "$1" = "-R" ]
then
    arborescence "."
else
    afficher $list
fi

