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
    trie $list    
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

function trie(){
    local param="$@"
    local trier="NON"
    local compteur=0
    #Représente notre mot en $i-1, qui va être comparé avec $i.
    local tmp=
    #Nos mots à échanger.
    local elem1=
    local elem2=
    #Nos variables de comparaison
    local testI
    local testTmp
    #Permet de determiner si on utilise une comparaison avec des entiers
    local intCompa=0
    
    while [ "$trier" == "NON" ] 
    do
        trier="OK"
        compteur=0
        tmp=
        for i in $param
        do
            compteur=`expr $compteur + 1`
            #if [ $i ] && [ $tmp ]
            #then
                local j=1
                if [ $options ]
                then
                    local n=`expr length $options`
                    if [ $j -le $n ]
                    then
                        comparer $j
                    fi
                fi
                if [ $intCompa == 1 ]
                then
                    if [ $compteur -ge 2 ] && [ "$testI" -lt "$testTmp" ] 
                    then
                        elem1="$tmp"
                        elem2="$i"
                        #On échange les deux dans la chaine.
                        param=$(swapSideBySide $param)
                        trier="NON"
                        break
                        j=1
                    fi
                else
                    if [ $compteur -ge 2 ] && [ "$testI" \< "$testTmp" ] 
                    then
                        elem1="$tmp"
                        elem2="$i"
                        #On échange les deux dans la chaine.
                        param=$(swapSideBySide $param)
                        trier="NON"
                        break
                        j=1
                    fi
                fi
                
            #fi
            tmp=$i
        done
    done
    list=$param
}

function comparer(){
    #Cette fonction permet d'initialiser les variables a comparer avant de les echanger
    #Param : $1 j
    if [ $options ]
    then    
        if [ ${options:0:1} != "-" ]
        then
            echo "Err :${options:0:1} Element inconnu"
            exit
        fi
        local tester=${options:$1:1}
    else
        local tester="n"
    fi
    if [ $i ] && [ $tmp ]
    then
        if [ $tester == "n" ]
        then 
            intCompa=0
            testI=$i
            testTmp=$tmp
        fi
        if [ $tester == "l" ]
        then 
            intCompa=1
            if [ -d $i ]
                then testI=0
                else testI=$(wc -l < $i)
                fi
            if [ -d $tmp ]
                then testTmp=0
                else testTmp=$(wc -l < $tmp)
            fi
        fi
        if [ $tester == "e" ]
        then 
            intCompa=0
            if [ -d $i ]
                then testI=" "
                else testI="${i##*.}"
            fi
            if [ -d $tmp ]
                then testTmp=" "
                else testTmp="${tmp##*.}"
            fi  
        fi
        if [ $tester == "p" ]
        then
            intCompa=0
            testI=$(stat -c "%U" $i)
            testTmp=$(stat -c "%U" $tmp)
        fi
        if [ $tester == "g" ]
        then
            intCompa=0
            testI=$(stat -c "%G" $i)
            testTmp=$(stat -c "%G" $tmp)
        fi
        if [ $tester == "m" ]
        then
            intCompa=0
            testI=$(stat -c "%y" $i)
            testTmp=$(stat -c "%y" $tmp)
        fi
    fi
}

#Variable recuperant uniquement les options du programme
if [ $1 ]
then
    if [ $1 == "-R" ]
    then
        if [ $2 ]
        then
            if [ $2 == "-d" ]
            then
                inverse=$2
                if [ $3 ]
                then
                    options=$3
                fi
            else
                options=$2
            fi 
        fi
    else
        if [ $1 == "-d" ]
        then    
            inverse=$1
        else
            options=$1
        fi
    fi
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