#!/bin/bash

# (ordre : répertoire, fichier, liens, fichier spécial de type bloc, fichier spécial de type caractère, tube nommé, socket)
# -t : tri suivant le type de fichier

# 1er symbole : 
#d--------- : répertoire
#-rwxrwxrwx : fichier
#l--------- : liens
#b--------- : f. spé. de type de bloc
#c--------- : f. spé. de type caractère
#p--------- : tube nommé
#s--------- : socket

# Exemple : stat -c '%A' tailleTEST.sh
# Résultat : -rwxrwxrwx

#Fonction qui permet de tri la chaine passé en paramètre, en fonction du type de fichier.
#Paramètre : la chaine à modifier (chaine contenant les noms de fichiers | Actuellement : QUE les noms de fichiers |).
#Retourne la nouvelle chaine, la chaine trier donc en fonction du fichiers.
function fonction_T(){
    local param="$@"
    local compteur=0
    local tmp="NONE"
    #Variables pour un tri plus simple, mais plus gourmand.
    local repertoire=
    local fichier=
    local liens=
    local bloc=
    local caractere=
    local tube=
    local socket=
    #Chaine triée de retour.
    local newChaine=
    for i in $chainePermission
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
                    #Si ..
                    if [ "$tmp" == "(d)" ] 
                    then
                        repertoire="$repertoire $i"
                    elif [ "$tmp" == "(-)" ] 
                    then
                        fichier="$fichier $i"
                    elif [ "$tmp" == "(l)" ] 
                    then
                        liens="$liens $i"
                    elif [ "$tmp" == "(b)" ] 
                    then
                        bloc="$bloc $i"
                    elif [ "$tmp" == "(c)" ] 
                    then
                        caractere="$caractere $i"
                    elif [ "$tmp" == "(p)" ] 
                    then
                        tube="$tube $i"
                    elif [ "$tmp" == "(s)" ] 
                    then
                        socket="$socket $i"
                    fi
                fi
            done
        fi
        tmp=$i
    done

    newChaine="$repertoire $fichier $liens $bloc $caractere $tube $socket"

    echo $newChaine
}

#Reprise de code (via l'ancienne fonction "affichage") et modification.
function permissionWithName(){
    local tmp=
    for i in *
    do
        if [ "$i" != "*" ]
        then
            tmp="$(stat -c '%A' $i)"
            tmp="(${tmp:0:1}) $i"
            chainePermission=" $chainePermission| $tmp\n"
	    fi
        
        if [ $# -gt 0 ] && [ $1 = "-t" ] && [ -d $i ]
        then
            dossiers=$dossiers' '$i
        fi
    done
}

#Reprise de code (via l'arborescence récursivement : -R) puis modifier.
function permission(){
    local dossiers=
    permissionWithName "-t"
    for j in $dossiers
    do
        cd $j
        permission "$1/$j"
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

#Test si il y a -t en paramètres.
chainePermission=
if [ "$1" = "-t" ]
then
    permission $rep
else
    permissionWithName
fi

chainePermission="$(echo -e $chainePermission)" #Chaine avec la permission et le nom du fichier.
echo "Notre 'ls' avec les permissions : "
echo "$chainePermission"
chaineAFaire="tmp fichier1 fichier2 dossier1 fichier3" #Chaine exemple comportant les fichiers et répertoires que l'on souhaite trier.
echo "Imaginons que nous voulions trier la chaine suivante : '$chaineAFaire'"
chaineAFaire=$(fonction_T $chaineAFaire)
echo "Resultat (ordre : d, -, l, b, c, p, s) : '$chaineAFaire'"