#!/bin/bash

function swap(){
#   tmp=
#   trier == "NON"
#   Tant que trier == "NON"
#    |   trier="OK"
#    |   pour i allant du 1er elem au dernier elem
#    |    |   si i!=$1 et i < tmp alors ..
#    |    |    |   on échange les deux elem
#    |    |    |   trier="NON"
#    |    |   tmp = i
    local tmp=
    local tempo=
    local cmpt=0
    local calcul=0
    local trier="NON"
    while [ "$trier" == "NON" ] 
    do
        trier="OK"
        for i in $@ 
        do
            cmpt=`expr $cmpt + 1`
            if [ "$i" != "$1" ] && [ "$i" \< "$tmp" ] 
            then
                tempo=${@:$cmpt:1}
                #tempo puis tmp .. Comment modifier l'élément dans la chaine .. 
                ${@:$cmpt:1}=$tmp
                cmpt=`expr $cmpt - 1`
                ${@:$cmpt:1}=$tempo
                cmpt=`expr $cmpt + 1`
                trier="NON"
            fi
            tmp=$i
        done
    done
}

function fct_n(){
    local tmp=
    local newListe=
    echo ""
    for i in $@ 
    do
        if [ "$i" \< "$tmp" ] 
        then
            echo "'$i' < '$tmp'"
            newListe="$i $newListe"
        else
            echo "'$i' > '$tmp'"
            newListe="$newListe $i"
        fi
        tmp=$i
    done

    echo "$(swap $newListe)"
}

if [ "$1" = "-n" ] 
then 
    listeAPasser="Abc Daa Boc Adc Zen"
    echo "Chaine initiale : '$listeAPasser'."
    # On appel la fonction ..
    nouvelleListe=$(fct_n $listeAPasser)
    echo "Nouvelle liste : '$nouvelleListe'."
else 
    echo "Besoin du -n !"
fi
