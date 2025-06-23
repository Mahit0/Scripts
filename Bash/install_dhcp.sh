#!/bin/bash
#####################################
# Author : Mahito_                  #
# Date : 10/05/2024                 #
# Name : install_dhcp.sh            #
# Version : 1.0                     #
#####################################

#Définition des couleurs 
Vert='\033[0;32m'
Cyan='\033[0;36m'
Rouge='\033[0;31m'
Brun='\033[0;33m'
Cyansoul='\033[4;36m'
Question='\033[1;36m'
NC='\033[0m'

## Installation des paquets requis pour le bon fonctionnement du script 
# Vérification si le paquet nala est bien installé 
if dpkg -l | grep nala 2>/dev/null; then 
    echo "${Vert}✅ Nala est bien installé sur le serveur${NC}"
else
    echo "📦 Installation de Nala en cours..."
    apt install -y nala
fi 

# Verification si le paquet isc-dhcp-server est bien installé 
if dpkg -l | grep isc-dhcp-server 2>/dev/null; then
    echo "${Vert}✅ isc-dhcp-server est déjà installé sur le serveur${NC}"
else 
    echo "📦 Installation de ISC-DHCP-SERVER en cours..."
    nala install -y isc-dhcp-server
fi

# Verification si le paquet ipcalc est bien installé 
if dpkg -l | grep ipcalc 2>/dev/null; then
    echo "${Vert}✅ ipcalc est déjà installé sur le serveur${NC}"
else 
    echo "📦 Installation de ipcalc en cours..."
    nala install -y ipcalc
fi

# Récupération des cartes réseaux et des adresses IP v4 et stockage de ces derniers dans les variables int & ip_choose
list_ip=$(ip -o -4 a | awk '{print $2, $4}') 
echo "${Question}Voici les différentes interfaces & adresses IP disponible sur ton serveur${NC}"
echo "${Brun}${list_ip}${NC}"
read -p "$(echo "${Question}Entre le nom de l'interface que tu veux utiliser pour ton DHCP :${NC}")" int
ip_choose=$(ip -o -4 a | awk '{print $2, $4}' | grep ${int} | awk '{print $2}')

## Configuration du serveur DHCP en fonction des informations entrées precedement 
#sed -i '4 s/^#//' /etc/default/isc-dhcp-server 
#sed -i "17 s/^\(..............\)/\1${int}/" /etc/default/isc-dhcp-server

# Configuration du bail & plage DHCP
read -p "$(echo "${Question}Combien de temps doit durer le bail DHCP (en secondes stp) :${NC}")" bail_dhcp
read -p "$(echo "${Question}Donne moi la 1er adresse IP de ta plage DHCP (Elle doit etre dans le réseau de ton serveur) :${NC}")" first_ip_dhcp
read -p "$(echo "${Question}Quel est la dernière IP de ta plage DHCP (Elle doit toujours etre dans le réseau de tons serveur) :${NC}")" last_ip_dhcp
read -p "$(echo "${Question}Est ce que tu as un serveur DNS ? y/n : ${NC}")" dns
case $dns in
    yes|y|oui|o|Yes|Y|Oui|O)
        read -p "$(echo "${Question}Entre l'adresse IP de ton DNS (elle doit encore etre dans ton réseau) : ${NC}")" dns_ip
        ;;
    no|n|No|non|Non)
        echo "Ok pas de soucis, passons à la suite 😄"
        ;;
esac
read -p "$(echo "${Question}Donne moi l'adresse IP de ta passerelle par défaut / Gateway (toujours dans ton réseau) ${NC}")" gateway

# Separe IPV4 & CIDR
ip_addr=$(echo "${ip_choose}" | cut -d'/' -f1)
cidr=$(echo "${ip_choose}" | cut -d'/' -f2)

cidr_to_netmask() {
  local i mask=""
  local full_octets=$((cidr / 8))
  local remaining_bits=$((cidr % 8))

  for ((i = 0; i < 4; i++)); do
    if ((i < full_octets)); then
      mask+="255"
    elif ((i == full_octets)); then
      mask+=$((256 - 2 ** (8 - remaining_bits)))
    else
      mask+="0"
    fi
    [[ $i -lt 3 ]] && mask+="."
  done
  echo "$mask"
}
netmask=$(cidr_to_netmask)
echo ${netmask}

cat > /etc/dhcp/dhcpd.conf <<EOF
default-lease-time ${bail_dhcp};
max-lease-time ${bail_dhcp};
authoritative;
log-facility local7;

EOF