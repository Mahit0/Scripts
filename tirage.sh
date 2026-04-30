#!/bin/bash

#################################
# Author : Ottema05             #
# File : tirage.sh              #  
# Edit : 29/04/2026             #
# Last commit by : Ottema05     #
#################################

### Tout d'abbord on part du principe qu'il ya le nom d'une victime par ligne dans le fichier $liste ###

# On demande un fichier si on a aucun support pour le tas
if [[ -z $1 ]] ; then 
    read -p "Donne moi ton path vers la liste de tes victimes : " liste
else 
    liste=$1
fi 

file_vic_tas=/tmp/vic_tas.$$
# On verif qu'on a un fichier de pret pour mettre le noms de ceux qui ont ete tas 
if [[ ! -f ${file_vic_tas} ]] ; then 
    touch ${file_vic_tas}
else
    # Si existe on s'assure qu'il est vide
    > ${file_vic_tas}
fi

# On cree la fonction du tas 
function func_tas_victime {
    nb_victime=$(cat ${liste} | wc -l)
    
    nb_deja_tas=$(cat ${file_vic_tas} | wc -l)
    if [[ ${nb_deja_tas} -ge ${nb_victime} ]]; then
        echo "Deso poto, tout le monde est deja passe à la casserole ! (Option 2 pour reset)"
        return
    fi

    victime_name=""
    until [[ -n "${victime_name}" ]] && ! grep -qx "${victime_name}" "${file_vic_tas}"; do
        victime_line=$(shuf -i 1-${nb_victime} -n 1)
        victime_name=$(sed -n "${victime_line}p" "${liste}")
    done

    echo "Et le grand gagnant est : ${victime_name}" 
    echo "${victime_name}" >> "${file_vic_tas}" 
}
func_tas_victime

until [[ ${check_fin} == "OK" ]] ; do 
    echo "-----------------------------------------------------------------"
    echo "1 - Tu t'amuse bien et tu veux tire une nouvelle victime ?"
    echo "2 - On remets les compteurs a zero"
    echo "3 - Assez jouer on arrete les conneries"
    echo "-----------------------------------------------------------------"
    read -p "Que souhaites-tu faire ? : " choice
    case ${choice} in 
        1)
            clear
            func_tas_victime
            ;;
        2)
            > ${file_vic_tas}
            clear
            echo "C'est bon chef les compteurs sont remis a zero 😈 "
            ;;
        3)
            echo "Roooooh tu es pas fun, mais bon ok c'est ton choix..."
            check_fin=OK
            ;;
        *)
            echo "Fait un choix entre 1 2 ou 3"
            ;;
    esac
done