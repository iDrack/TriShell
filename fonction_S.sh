#!/bin/bash

#Fonction qui permet de supprimer un mot unique n'importe où dans une chaine.
#Paramètre : chaine entière où l'on sup. (1) élément unique (attention à la variable "choix" situé dans la fonction qui l'appel).
#Retourne la chaine sans le mot que nous voulions sup. !
function supMotOnSentence(){
    local tmp=0
    local partD=
    local partG=
    local cmpt=0
    for i in $@ 
    do
        cmpt=`expr $cmpt + 1`
        if [ "$i" == "$choix" ] 
        then
            tmp=`expr $cmpt + 1`
            partD=${@:$tmp}
            tmp=`expr $cmpt - 1`
            partG=${@:1:$tmp}
            break
        fi
    done
    echo "$partG $partD"
}

#Fonction qui permet de tri la chaine passé en paramètre, en fonction de la taille des fichiers (+ petit au + grand)
#Paramètre : la chaine à modifier (chaine contenant les noms de fichiers | Actuellement : QUE les noms de fichiers |).
#Retourne la nouvelle chaine, la chaine trier donc en fonction de la taille de ces fichiers.
#Particularité : retourne la taille avec le nom.
#Modification(s) possible : peut être modifier pour ne mettre que le nom, voir davantage d'informations via des tris précédents ..
function fonction_S(){
    local param="$@"
    local compteur=0
    local tmp=
    local newChaine=
    for i in $chaineSize
    do 
        compteur=`expr $compteur + 1`

        #Si le compteur est sup ou égal à 2.
        if [ $compteur -ge 2 ] 
        then
            for j in $param
            do
                #Si le nom du fichier 
                if [ "$i" == "$j" ] 
                then
                    #echo "$i == $j"
                    newChaine="$newChaine $tmp $i"
                    #echo "$tmp $i"
                fi
            done
        fi

        tmp=$i
    done

    compteur=0
    for i in $newChaine
    do
        compteur=`expr $compteur + 1`
    done

    param=$newChaine
    local chaineTempo="0"
    local inTempo="NON"
    local chaineRetour=
    local parcours=
    local verif="OK"
    local choix=
    tmp=0

    while [ $compteur -ne 0 ] 
    do
        tmp=0
        compteur=`expr $compteur - 1`
        for i in $param
        do
            inTempo="NON"

            if [[ "$i" =~ ^[-+]?[0-9]+$ ]] 
            then
                for j in $chaineTempo
                do
                    if [ "$i" == "$j" ] 
                    then
                        inTempo="IN"
                        break
                    fi
                done

                #Si i > tmp && pas dans la liste tempo. alors tmp = i
                if [ $i -gt $tmp ] && [ "$inTempo" == "NON" ] 
                then
                    tmp=$i
                fi
            fi
        done

        verif="OK"
        for j in $chaineTempo
        do
            if [ "$tmp" == "$j" ] 
            then
                verif="IN"
                break
            fi
        done
        if [ "$inTempo" == "NON" ] && [ "$verif" == "OK" ] 
        then
            chaineTempo="$tmp $chaineTempo"
            choix="$tmp"
            param=$(supMotOnSentence $param)
            #On ajoute tmp au retour ..
            parcours=0
            for i in $newChaine 
            do
                if [ "$parcours" != "0" ] 
                then
                    chaineRetour="$parcours $i $chaineRetour"
                    break
                fi

                if [ "$i" == "$tmp" ] 
                then
                    parcours="$i"
                fi
            done  
        fi
    done

    echo $chaineRetour
}

#Reprise de code (via l'ancienne fonction "affichage") et modification.
function sizeWithName(){
    local tmp=
    for i in *
    do
        if [ "$i" != "*" ] && [ ! -d "$i" ] 
        then
            tmp="$(wc -c $i)"
            chaineSize=" $chaineSize| $tmp\n"
	    fi
        
        if [ $# -gt 0 ] && [ $1 = "-s" ] && [ -d $i ]
        then
            dossiers=$dossiers' '$i
        fi
    done
}

#Reprise de code (via l'arborescence récursivement : -R) puis modifier.
function sizeOfAll(){
    dossiers=
    sizeWithName "-s"
    for j in $dossiers
    do
        cd $j
        sizeOfAll "$1/$j"
	    cd ..
    done
}

#ATTENTION : code identique dans le trishell (NE PAS COPIER COLLER)
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

#Test si il y a -s en paramètres.
chaineSize=
if [ "$1" = "-s" ]
then
    sizeOfAll $rep
else
    sizeWithName
fi

chaineSize="$(echo -e $chaineSize)" #Chaine avec la taille et le nom du fichier.
echo "Voici l'equivalent de notre 'ls' : "
echo "$chaineSize"
chaineAFaire="fonction_N.sh fonction_S.sh trishell.sh" #Chaine exemple comportant les fichiers dont on souhaite la taille.
echo "Imaginons que nous voulions trier la chaine suivante : '$chaineAFaire'"
chaineAFaire=$(fonction_S $chaineAFaire)
echo "Voici le resultat (avec les tailles des fichiers) : '$chaineAFaire'"