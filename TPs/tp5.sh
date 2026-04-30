#!/bin/bash

#################################
# Author : Ottema05             #
# File : tp5.sh                 #  
# Edit : 28/04/2026             #
# Last commit by : Ottema05     #
#################################

# On check si $1 est vide ou non 
if [[ -n $1 ]] ; then 
    filter_name=$1
else
    # Si vide on demande un filter_name
    read -p "Donne moi un critere de recherche : " filter_name
    # Si vraiement le mec ne fais aucun effort et a rien mis -> filter_name = username
    if [[ -z ${filter_name} ]] ; then 
        filter_name=$(whoami)
    fi
fi

# On check si il y a plusieurs arguments
check_filter_content=$(echo ${filter_name} | wc -w)

if [[ ${check_filter_content} -gt 1 ]] ; then 
    echo "Utilisation : <get-process.sh> [nom_process]"
    exit 3
fi

# On regarde les process en cours et on filtre avec le filtre
filter_process=$(ps aux | grep ${filter_name})

# On affiche le resultat final
echo "--------------------------------------------------------------"
echo "Liste des processus contenant ${filter_name}"
echo "--------------------------------------------------------------"
echo "Ligne de legende des differents champs affiches :"
echo "$(ps aux | head -n1)"
echo "${filter_process}"
echo "--------------------------------------------------------------"

echo "$(date +%T) - Fin de traitement"