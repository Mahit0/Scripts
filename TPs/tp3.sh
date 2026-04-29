#!/bin/bash

#################################
# Author : Ottema05             #
# File : tp3.sh                 #  
# Edit : 27/04/2026             #
# Last commit by : Ottema05     #
#################################

# On recup les infos 
rep=$(pwd)
extension="*.txt"

echo "Voici le chemin vers le repertoire de travail : ${rep}"
if [ -f ${extension} ] ; then 
    echo "Voici une liste des fichiers pouvant etre traite : "
    ls -l ${rep}/${extension}
else
    echo "Deso mec tu ne peux pas bosser car je ne trouve pas de fichier txt dans ${rep}"
fi

read -p "Quel fichier voulez-vous traiter ?" fic
nblign=$(wc -l  ${rep}/${fic}.${extension})
debut=$(head -n2 ${rep}/${fic}.${extension})
fin=$(tail -n2 ${rep}/${fic}.${extension})

echo "CARACTERISQUES DE ${fic}"
echo "Nombre de lignes du fichier : ${nblign} lignes"
echo "2 premieres lignes du fichier : ${debut}"
echo "2 dernieres lignse du ficheir : ${fin}"

