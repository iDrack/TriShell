#!/bin/bash

#list nous permettra de faire nos operations de tri
list=''

#Fonctions permettant d'operer sur notre liste
function ajout(){
    list=$list' '$1
}

function taille_de(){
    return $#
}

function afficher(){
    for e in $@
        do
        echo $e
        done
}

function suppression(){
    #Premier parametre = elem a supp, second parametre =list
    tmp=''
    for e in $@
        do
        if (test $e != $1);then  tmp=$tmp' '$e; fi
        done
    list=$tmp
}

if [ "$1" = "-R" ]
then
    echo ".:"
fi
for i in *
    do
    echo -ne "$i\t"
done
echo ""
if [ "$1" = "-R" ]
then
    for i in *
    do
        if [ -d "$i" ]
        then
            cd $i
	    echo -e "\n./$i:"
            for i in *
            do
                echo -ne "$i\t"
            done
	    echo ""
            cd ..
        fi
    done
fi

