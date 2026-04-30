#!/bin/bash

#################################
# Author : Ottema05             #
# File : creatusersMAJ.sh       #  
# Edit : 29/04/2026             #
# Last commit by : Ottema05     #
#################################

if [ "$EUID" != "0" ]; then
    echo "Lance ce script en sudo ou root salopio !"
    exit 1 
fi

function log {
    echo -e "$(date +%c) - $1"
}

log_file=/var/log/create_user_maj_fails.log
crea_user_file=/tmp/listusersmaj.txt

if [ ! -f "$crea_user_file" ]; then
    echo "${crea_user_file} existe pas "
    exit 1
fi

OK=0
KO=0
tmp_fails=$(mktemp)

cat "$crea_user_file" | while read -r user home shell || [ -n "$user" ]; do
    if [ -z "$user" ]; then
        continue
    fi

    if [ -z "$shell" ] || [ ! -x "$shell" ]; then
        final_shell="/bin/bash"
    else
        final_shell="$shell"
    fi
    useradd -m -d "$home" -s "$final_shell" "$user" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        log "Succès : $user ($home, $final_shell)"
        OK=$((OK + 1))
    else
        log "Échec : $user" >> "$log_file"
        echo "$user $home $shell" >> "$tmp_fails"
        KO=$((KO + 1))
    fi
done

cat "$tmp_fails" > "$crea_user_file"
rm "$tmp_fails"

echo "Terminé. Succès: $OK | Échecs: $KO"