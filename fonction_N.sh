#!/bin/bash

#Fonction qui permet d'échange deux mot côte à côte (side by side).
#Paramètre : la chaine à modifier (les deux mots à echanger étant déterminer dans la fonction qui l'appel).
#Retourne la nouvelle chaine donc.
function swapSideBySide(){
    local p1=
    local p2=
    local cmpt=0
    for i in $@ 
    do
        cmpt=`expr $cmpt + 1`
        if [ "$i" == "$elem1" ] 
        then
            cmpt=`expr $cmpt - 1`
            p1=${@:1:$cmpt}
            cmpt=`expr $cmpt + 1`
        fi
        
        if [ "$i" == "$elem2" ] 
        then
            cmpt=`expr $cmpt + 1`
            p2=${@:$cmpt}
            break
        fi
    done
    #echo "p1 : $p1"
    #echo "p2 : $p2"
    echo "$p1 $elem2 $elem1 $p2"
}

#Fonction qui permet de tri la chaine passé en paramètre, en fonction des noms dans la chaine (ordre alphabétique).
#Paramètre : la chaine à modifier (chaine contenant les noms de fichiers qui l'on doit trier par ordre alphabétique).
#Retourne la nouvelle chaine, la chaine trier donc.
function fct_n(){
    local param="$@"
    local trier="NON"
    local compteur=0
    #Représente notre mot en $i-1, qui va être comparé avec $i.
    local tmp=
    #Nos mots à échanger.
    local elem1=
    local elem2=
    
    while [ "$trier" == "NON" ] 
    do
        trier="OK"
        compteur=0
        tmp=
        for i in $param
        do
            compteur=`expr $compteur + 1`
            #Si le compteur est sup ou égal à 2 et le mot courant < au mot d'avant alors on échange.
            if [ $compteur -ge 2 ] && [ "$i" \< "$tmp" ] 
            then
                elem1="$tmp"
                elem2="$i"
                #On échange les deux dans la chaine.
                param=$(swapSideBySide $param)
                trier="NON"
                break
            fi
            tmp=$i
        done
    done

    echo $param
}

#Si on a bien le paramètre -n alors on fait le tri. PS : $1 n'est que temporaire, le temps de merge le tout.
if [ "$1" = "-n" ] 
then 
    chaine="Az bd Aa Dbz Brout Test"
    #chaine="az ad ae aa"

    echo "Chaine avant l'appel : $chaine"
    chaine=$(fct_n $chaine)
    echo "Chaine après l'appel : $chaine"
else 
    echo "Besoin du -n !"
    echo "Juste un -n sans rien derriere .. ^^"
fi
