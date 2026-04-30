#!/bin/bash

#################################
# Author : Ottema05             #
# File : tp10.sh                #  
# Edit : 30/04/2026             #
# Last commit by : Ottema05     #
#################################

# On definit les variables globales
path=$(pwd)

# On recup nos fonctions 
if [[ ! -f ${path}/fonctions.fonc ]] ; then 
    echo "Je ne trouve pas le fonctions.fonc"
    exit 1 
fi 
source ${path}/fonctions.fonc

echo "-------------------------------------------------------------------"
echo "1 - Tu souhaites faire une sauvegarde des tes scripts"
echo "2 - Tu souhaites supprimer tes sauvegardes"
echo "3 - Tu es prudent et tu veux check si tu as des sauvegardes"
echo "-------------------------------------------------------------------"
read -p "Que souhaites-tu faire ? : " choice

case ${choice} in 
    1) 
        save_shell
        ;;
    2)
        suppr_save
        ;;
    3)
        check_save
        ;;
    *)
        echo "Entre un choix valide..."
        ;;
esac
