#!/bin/bash

function ajout {
    #Fonction permettant d'operer sur notre liste
    list=$list' '$1
}

function taille_de {
    #Fonction retournant la taille de la liste passée en paramètres
    return $#
}

function afficher {
    #Affiche les fichiers present dans le répertoire
    for i in *
    do
        if [ "$i" != "*" ]
        then
            echo -ne "$i\t"
            #Ajoute le fichier dans la liste si c'est un dossier et qu il y a -R en param
            if [ $# -gt 0 ] && [ $1 = "-R" ] && [ -d $i ]
            then
                dossiers=$dossiers' '$i
            fi
	    fi
    done
    echo ""
}

function suppression {
    #Premier paramètre = elem à supp, second paramètre = list à manipuler
    tmp=''
    for e in $@
    do
        if (test $e != $1);then  tmp=$tmp' '$e; fi
    done
    list=$tmp
}

function inverser_ordre {
    #Permet d inverser la liste d éléments
    tmp=''
    for e in $@
    do
        tmp=$e' '$tmp
    done
    list=$tmp
}

function new_list {
    #Permet de créer une nouvelle liste et de gérer les options
    #Il faudra passer en paramètres les options passées lors de l appel de la commande
    list=*
    for e in $@
        do
        if [ "$e" = "-d" ]
            then
            inverser_ordre $list
        fi
    done
}

#Parcours l'arborescence récursivement : -R.
function arborescence {
    dossiers=''
    echo -e "\n$1:"
    afficher "-R"
    for j in $dossiers
    do
        cd $j
        arborescence "$1/$j"
	    cd ..
    done
}

#Va au repertoire entré en paramètres : -R.
rep='.'
for i in $@
do
    if [ -d "$i" ] && [ "$rep" = '.' ]
    then
	    rep=$i
    fi
done
cd $rep

#       trishell [-R] [-d] [-nsmletpg] rep
# Ex :  trishell -R -d -pse /home

#Test si il y a -R en paramètres.
if [ "$1" = "-R" ]
then
    arborescence $rep
else
    afficher
fi

