#!/bin/bash

#################################
# Author : Ottema05             #
# File : tp2.sh                 #  
# Edit : 27/04/2026             #
# Last commit by : Ottema05     #
#################################

# On def nos variables qui vont nous etre utile pour le script
bin_bash=$(whereis bash | awk '{print $2}')
man_bash_rep=$(whereis bash | awk '{print $3}')
common_bashrc="/etc/bashrc"

# On def un function pour avoir la date & heure pour les logs
log() {
    echo -e "$(date +%c) - $1"
}

# On affiche les msg de courtoisie :)
echo "Bonjour, cette machine est fin prete pour scripter..."
echo "Scripts Shell present ici :"

# On check si des fichier .sh sont present dans le rep actuel
if [ -f "*.sh" ] ; then 
    ls -l | grep *.sh
else
    echo "Deso frerot il y a aucun script shell dans ton rep"
fi

# On affiche une ligne blanche
echo ""

# On affiche toutes les infos utile a bash 
echo "Chemin vers le binaire de bash : ${bin_bash}"
echo "Chemin vers le bashrc commun a tous : ${common_bashrc}"
echo "Chemin vers le man de bash : ${man_bash_rep}"

# On check la distrib sous laquelle on est 
if lsb_release -a | grep "Debian" ; then 
    distrib="Debian"
    installateur="apt"
elif lsb_release -a | grep "Fedora" ; then 
    distrib="Fedora"
    installateur="dnf"
else 
    echo "Deso frerot je ne trouve pas ta distrib, je ne peux pas "
fi

check_maj=$(${installateur} list --upgradable)
if [ ${check_maj} == "bash" ] ; then
    echo "Il y a une maj de bash qui est dispo"
else
    echo "Ton packet bash est a jour bg"
fi