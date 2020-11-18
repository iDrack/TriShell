#!/bin/bash
# Projet réalisé par Charles Kempa, Thibaut Masnin et Thomas Dignoire.

################################### Fonctions ####################################

# Fonction permettant d'operer sur notre liste.
function ajout {
    list=$list' '$1
}

# Fonction retournant la taille de la liste passée en paramètres.
function taille_de {
    return $#
}

# Affiche les fichiers present dans le répertoire.
function afficher {
    list=*
    # Triage des elements du repertoire.
    trie $list    
    # Verifie si on veut un affichage decroissant.
    if [ $inverse ] && [ $inverse == "-d" ]
    then 
        inverser_ordre $list 
    fi
    for i in $list
    do
        if [ "$i" != "*" ]
        then
            if [ -d $i ] 
            then
                echo -ne "\n ==> $i"
            else 
                echo -ne "\n --> $i"
            fi
            
            # Ajoute le fichier dans la liste si c'est un dossier et qu il y a '-R' en param. !
            if [ $# -gt 0 ] && [ $1 = "-R" ] && [ -d $i ]
            then
                dossiers=$dossiers' '$i
            fi
	    fi
    done
    echo ""
}

# Premier paramètre = elem à sup., second paramètre = liste à manipuler.
function suppression {
    tmp=''
    for e in $@
    do
        if (test $e != $1);then  tmp=$tmp' '$e; fi
    done
    list=$tmp
}

# Permet d'inverser la liste d'éléments.
function inverser_ordre {    
    local tmp=''
    for e in $@
    do
        tmp=$e' '$tmp
    done
    list=$tmp
}

# Permet de créer une nouvelle liste et de gérer les options.
# Il faudra passer en paramètres les options passées lors de l'appel de la commande.
function new_list {    
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
    if [ "$1" == "." ] 
    then
        echo -ne "\nRépertoire courant :"
    else 
        echo -ne "\nContenu de [$1] :"
    fi
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
    echo "$p1 $elem2 $elem1 $p2"
}

# Fonction regroupant tous les triés.
function trie(){
    local param="$@"
    local trier="NON"
    local compteur=0
    # Représente notre mot en $i-1, qui va être comparé avec $i.
    local tmp=
    # Nos mots à échanger.
    local elem1=
    local elem2=
    # Nos variables de comparaison.
    local testI
    local testTmp
    # Permet de determiner si on utilise une comparaison avec des entiers.
    local flag=0
    local n=0
    while [ "$trier" == "NON" ] 
    do
        trier="OK"
        compteur=0
        tmp=
        for i in $param
        do
            compteur=`expr $compteur + 1`
            # Le 'i' permet de savoir l'option a utiliser durant la comparaison.
            local j=1
            if [ $options ]
            then
                # Le 'n' correspond au nombre d'options passee en parametre (incluant le '-').
                n=`expr length $options`
                if [ $j -le $n ]
                then
                    # Compare les entrees actuels selon l'option $j.
                    comparer $j
                fi
            fi
            # Tant que les entrees a comparer sont egal et qu'il reste des options a exploiter on les compare.
            while [ $(($j+1)) -lt $n ] && [ $testI -lt $testTmp ]
            do
                # Permet de passer a l'option suivante.
                j=$(($j+1))
                comparer $j
            done
            if [ $flag -eq 1 ] && [ $compteur -ge 2 ] && [ $testI -lt $testTmp ] 
            then
                elem1="$tmp"
                elem2="$i"
                # On échange les deux dans la chaine.
                param=$(swapSideBySide $param)
                trier="NON"
                break
                j=1
            fi
            tmp=$i
        done
    done
    list=$param
}

# Parametre : entier determinant l'option a utiliser afin de comparer les entrees.
# Exemple: trishell.sh -el et comme parametre $1=2 alors on va comparer les entrees selon l'option l, le nombre de lignes que chaque entree comporte.
# Apres avoir determiner le facteur de comparaison des entrees, on les compare puis on initialise testI a 0 et testTmp a 1 si $i < $tmp et vice versa.
# TODO implementer un test verifiant que le char choisit pour la comparason soit legal.
function comparer(){
    flag=1 # Il permet de determiner que l'on ait passer par la fonction comparer.

    if [ $options ]
    then    
        # Verifie que le debut de nos options commence bien par un '-'.
        if [ ${options:0:1} != "-" ] 
        then
            echo "Err : ${options:0:1}, Element inconnu"
            exit
        fi
        # Initialise la variable tester au charactere a la position passer en parametre ($1).
        local tester=${options:$1:1}
        # Si cette variable ne correspond pas à une des options, on sort !
        if [ $tester != "n" ] || [ $tester != "s" ] || [ $tester != "m" ] || [ $tester != "l" ] || [ $tester != "e" ] || [ $tester != "t" ] || [ $tester != "p" ] || [ $tester != "g" ] 
        then
            echo "Err : $tester, Element inconnu"
            exit
        fi
    else
        # Si notre variable $options n'existe pas alors on utiliser le tri de l'option n par defaut.
        local tester="n"
    fi

    if [ $i ] && [ $tmp ]
    then
        if [ $tester == "n" ]
        then 
            if [ "$i" \< "$tmp" ]
            then
                testI=0
                testTmp=1
            else
                testI=1
                testTmp=0
            fi

        fi

        if [ $tester == "l" ]
        # Compare les deux valeurs selon le nombre de lignes des entrees.
        then
            # Pour l'option l, on ne fait pas le test testI < testTmp car dans l'algo principal on attend des entiers.
            # Or, ici, testI et testTmp sont des entiers.
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
        # Tri suivant l'extentions des entrees. 
        then 
            # On init testI et testTmp pour la comparaison.
            if [ -d $i ]
                then testI=" "
                else testI="${i##*.}"
            fi
            if [ -d $tmp ]
                then testTmp=" "
                else testTmp="${tmp##*.}"
            fi  
            # On les compare.
            if [ "$testI" \< "$testTmp" ]
            then
                # On initialise testI et testTmp avec des entiers afin que l'algo principal les reconnaisse.
                testI=0
                testTmp=1
            else
                testI=1
                testTmp=0
            fi
        fi

        if [ $tester == "p" ]
        # Tri suivant le nom du propietaire des entrees.
        then
            testI=$(stat -c "%U" $i)
            testTmp=$(stat -c "%U" $tmp)
            if [ "$testI" \< "$testTmp" ]
            then
                testI=0
                testTmp=1
            else
                testI=1
                testTmp=0
            fi
        fi

        if [ $tester == "g" ]
        # Tri suivant le groupe proprietaire des entrees.
        then
            testI=$(stat -c "%G" $i)
            testTmp=$(stat -c "%G" $tmp)
            if [ "$testI" \< "$testTmp" ]
            then
                testI=0
                testTmp=1
            else
                testI=1
                testTmp=0
            fi
        fi

        if [ $tester == "m" ]
        # Tri suivant la date de derniere modification des entrees.
        then
            testI=$(stat -c "%y" $i)
            testTmp=$(stat -c "%y" $tmp)
            if [ "$testI" \< "$testTmp" ]
            then
                testI=0
                testTmp=1
            else
                testI=1
                testTmp=0
            fi
        fi

        if [ $tester == "s" ]
        # Tri suivant la taille en bytes des entrees.
        then
            testI=$(stat -c "%s" $i)
            testTmp=$(stat -c "%s" $tmp)
        fi

        if [ $tester == "t" ]
        # Tri suivant le type des entrees.
        then
            testI=$(stat -c "%F" $i)
            # Si le fichier tester est un fichier regulier vide ca reste un fichier regulier.
            if [ "$testI" == "regular empty file" ]
            then
                testI="regular file"
            fi

            testTmp=$(stat -c "%F" $tmp)

            if [ "$testTmp" == "regular empty file" ]
            then
                testTmp="regular file"
            fi

            case "$testI" in "directory") testI=0;;
            "regular file") testI=1;;
            "symbolic link") testI=2;;
            "block special file") testI=3;;
            "character special file") testI=4;;
            "fifo") testI=5;;
            "socket") testI=6;;
            *);;
            esac

            case "$testTmp" in "directory") testTmp=0;;
            "regular file") testTmp=1;;
            "symbolic link") testTmp=2;;
            "block special file") testTmp=3;;
            "character special file") testTmp=4;;
            "fifo") testTmp=5;;
            "socket") testTmp=6;;
            *);;
            esac
        fi
    fi
}

###################################### MAIN ######################################

# Variable recuperant uniquement les options du programme.
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

# Va au repertoire entré en paramètres : '-R'.
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
    echo -ne "\nRépertoire courant : "
    afficher
fi