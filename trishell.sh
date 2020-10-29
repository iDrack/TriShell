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
    list=*
    #Triage des elements du repertoire
    #TODO fonction de gestion des options
    if [ $options ] && [ $options == "-n" ]
    then 
        fct_n $list
    fi
    if [ $options ] && [ $options == "-l" ]
    then 
        fct_l $list
    fi
    #Verifie si on veut un affichage decroissant
    if [ $inverse ] && [ $inverse == "-d" ]
    then 
        inverser_ordre $list 
    fi
    for i in $list
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
    local tmp=''
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
    list = $param
}

function fct_l(){
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
            if [ $i ] && [ $tmp ]
            then
                if [ -d $i ]
                    then testI=0
                    else testI=$(wc -l < $i)
                fi
                if [ -d $tmp ]
                    then testTmp=0
                    else testTmp=$(wc -l < $tmp)
                fi
                if [ $compteur -ge 2 ] && [ "$testI" \< "$testTmp" ] 
                then
                    elem1="$tmp"
                    elem2="$i"
                    #On échange les deux dans la chaine.
                    param=$(swapSideBySide $param)
                    trier="NON"
                    break
                fi
            fi
            tmp=$i
        done
    done
    list=$param
}

#Variable determinant si l'affichage doit etre decroissant
inverse=$2
#Variable recuperant uniquement les options du programme
#TODO fonction gerant les options du preogramme
if [ $2 == "-d" ] 
    then options=$3
    else options=$2
fi

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