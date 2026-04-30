#!/bin/bash

#################################
# Author : Ottema05             #
# File : tp6.sh                 #  
# Edit : 28/04/2026             #
# Last commit by : Ottema05     #
#################################

# On check si le script est lancer en super user
if [[ $EUID != "0" ]] ; then
    echo "Lance ce script en sudo ou root salopio !"
    exit 1 
fi

# On demande le nom d'utilisateur 
until [[ -n ${username} ]] ; do
    read -p "Donne moi le nom d'utilisateur avec lequel tu souhaite jouer : " username
done

## On gere nos fonctions 
function func_check_user {
    if cat /etc/passwd | grep ${username} ; then 
        check_user="OK"
    else
        check_user="KO"
    fi
}

function func_reset_mdp {
    until [[ -n ${mdp} ]] ; do 
        read -p "Donne moi un mot de passe pour ton utilisateur : " mdp 
    done
    echo "${username}:${mdp}" | chpasswd
}

backup_path=/var/backup/

until [[ -n ${check_until} ]] ; do 
    # Affichage du menu
    clear
    echo "Gestion de l'utilisateur ${username}"
    echo "-------------------------------------------------"
    echo "C - Creer le compte utilisateur"
    echo "M - Modifier le mot de passe du user"
    echo "S - Supprimer le compte utilisateur"
    echo "V - Verifier que le compte existe"
    echo ""
    echo "Q - Quitter"
    echo "-------------------------------------------------"
    read -p "Quel est ton choix ? : " choice

    case ${choice} in 
        C)
            func_check_user
            if [[ ${check_user} == "KO" ]] ; then
                useradd -m -s /bin/bash ${username}
                func_reset_mdp
                echo "Ton utilisateur ${username} a bien ete cree !"
                check_until="OK"
            else
                echo "Ton utilisateur exise deja"
                exit 2
            fi 
            ;;
        M)
            func_check_user
            if [[ ${check_user} == "OK" ]] ; then 
                func_reset_mdp
                echo "Ton MDP a ete changer !"
                check_until="OK"
            else
                echo "Ton utilisateur exitse pas"
                exit 3
            fi
            ;; 
        S)
            func_check_user
            if [[ ${check_user} == "OK" ]]; then 
                if [[ ! -d ${backup_path} ]] ; then 
                    mkdir -p ${backup_path}
                fi
                deluser --backup --backup-to ${backup_path} --remove-home ${username}
                echo "${username} a bien ete purge"
                check_until="OK"
            else
                echo "Ton utilisateur existe pas"
                exit 3
            fi
            ;;
        V)
            func_check_user
            if [[ ${check_user} == "OK" ]]; then 
                echo "Ton utilisateur existe"
                check_until="OK"
            else 
                echo "Ton utilisateur existe pas"
                check_until="OK"
            fi
            ;;
        Q)
            exit 9
            ;;
        *) 
            echo "choix incorect BG... try again ;)"
            sleep 2 
            clear
            ;;
        esac
done