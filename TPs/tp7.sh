#!/bin/bash

#################################
# Author : Ottema05             #
# File : tp7.sh                 #  
# Edit : 28/04/2026             #
# Last commit by : Ottema05     #
#################################

# On check si le script est lancer en super user
if [[ $EUID != "0" ]] ; then
    echo "Lance ce script en sudo ou root salopio !"
    exit 1 
fi

# On cree la function pour les logs 
function log {
    echo -e "$(date +%c) - $1"
}

# On check si le fichier de log existe 
log_file=/var/log/create_user_fails.log
if [[ ! -f ${log_file} ]] ; then 
    touch ${log_file}
fi

# On demande un prefix des users
until [[ -n ${prefix_user} ]]; do
    read -p "Donne moi un prefix pour tes users : " prefix_user
done

# On demande cmb de user il faut create 
until [[ ${check_nb} == "OK" ]] ; do 
    read -p "Combien de user tu veux cree ? : " nb_user
    world_nb=$(echo ${nb_user} | wc -w)
    if [[ ${world_nb} == 1 ]] ; then 
        if [[ ${world_nb} =~ ^[0-9]+$ ]] ; then 
            check_nb="OK"
        fi
    else
        echo "Mets qu'un seul prefix pas 1000 !"
    fi
done

# On demande le premier numero 
until [[ ${check_first} == "OK" ]] ; do 
    read -p "Nombre du premier utilisateur (par defaut 1) : " first_user
    world_nb=$(echo ${first_user} | wc -w)
    check_first=OK
done

dernier=$((first_user + nb_user))
compteur=${first_user}

# Boucle de création
KO="0"
OK="0"
while [[ ${compteur} -lt ${dernier} ]] ; do 
    username="${prefix_user}${compteur}"
    
    # On tente la création
    useradd -m -s /bin/bash "${username}" 2>/dev/null
    
    if [[ $? -ne 0 ]] ; then 
        log "Erreur lors de la creation de ${username}" >> ${log_file}
        echo "Erreur lors de la creation de ${username}"
        KO=$((KO + 1))
    else 
        echo "Le compte ${username} a bien ete cree !"
        OK=$((OK + 1))
    fi 
    
    # Incrémentation propre en bash
    ((compteur++))
done

echo "----------------------------------------"
echo "${OK} Utilisateurs crees avec succes !"
echo "${KO} Utilisateurs n'a pas ete cree"
echo "Les echecs ont ete reportes dans : ${log_file}" 
echo "----------------------------------------"