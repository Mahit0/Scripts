#!/bin/bash

#################################
# Author : Ottema05             #
# File : creatuserslist.sh      #  
# Edit : 29/04/2026             #
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

log_file=/var/log/create_user_fails.log
crea_user_file=/tmp/listusers.txt

# Si le fichier existe pas, on peut pas bosser sur la liste
if [[ ! -f ${crea_user_file} ]] ; then 
    echo "Le fichier ${crea_user_file} est introuvable. On s'arrête là."
    exit 1
fi

# Initialisation des compteurs
OK=0
KO=0
# On va stocker temporairement ceux qui foirent
tmp_fails=$(mktemp)

# Boucle de lecture ligne par ligne
while read -r username; do
    # On skip les lignes vides au cas où
    [[ -z "$username" ]] && continue

    # On check si l'user existe déjà
    if id "$username" &>/dev/null; then
        log "L'utilisateur $username existe déjà." >> "${log_file}"
        echo "$username" >> "$tmp_fails"
        ((KO++))
    else
        # Tentative de création
        useradd "$username" &>/dev/null
        if [[ $? -eq 0 ]]; then
            log "Succès : $username a été créé."
            ((OK++))
        else
            log "Échec : Impossible de créer $username." >> "${log_file}"
            echo "$username" >> "$tmp_fails"
            ((KO++))
        fi
    fi
done 

# Mise à jour du fichier : on ne garde que les echecs
cat "$tmp_fails" > "${crea_user_file}"
rm "$tmp_fails"

echo "----------------------------------------"
echo "${OK} Utilisateurs crees avec succes !"
echo "${KO} Utilisateurs n'ont pas pu etre crees (voir liste dans ${crea_user_file})"
echo "Les logs d'erreurs sont ici : ${log_file}" 
echo "----------------------------------------"