#!/bin/bash

#####################################
# Author : Mahito_             #
# Date : 09/05/2024                 #
# Name : install_glpi.sh            #
# Version : 1.0                     #
#####################################

#Définition des couleurs 
Vert='\033[0;32m'
Cyansoul='\033[4;36m'
Cyan='\033[0;36m'
Question='\033[1;36m'
NC='\033[0m'

#Demande si l'utilisateur est sur le réseau de l'ENI ou non 
read -p "$(echo -e "${Question}Est ce que tu es sur le réseau de l'ENI ? :${NC}")" proxy_eni
case $proxy_eni in
    oui|o|Oui|yes|y|Yes)
        #Modifie les settings du proxy pour qu'il soit compatible avec celui de l'ENI
        echo 'export http_proxy="http://10.0.0.248:8080"' >> ~/.bashrc
        echo 'export https_proxy="http://10.0.0.248:8080"' >> ~/.bashrc
        source ~/.bashrc
        ;;
    non|n|Non|no|No)
        echo "Ok, pas de soucis, je n'installe pas php-ldap"
        ;;
esac
source ~/.bashrc
##Verification que les paquets : "apache2, php, mariadb-server" sont bien installer 
if dpkg -l | grep nala 2>/dev/numm; then 
    echo -e "${Vert}✅ Nala est bien installée sur le serveur${NC}"
else
    echo "📦 Installation de Nala en cours..."
    apt install -y nala
fi 
#Verif apache2
if dpkg -l | grep apache2 2>/dev/null; then 
    echo -e "${Vert}✅ Apache2 est bien installé${NC}"
else 
    echo "📦 Apache2 est en cours d'installation..."
    nala install -y apache2 
fi
#Verif php
if dpkg -l | grep php 2>/dev/null; then 
    echo -e "${Vert}✅ PHP est déjà installé${NC}"
else 
    echo "📦 Installation de PHP en cours..."
    nala install -y php 
fi
#Verif mariadb-server
if dpkg -l | grep mariadb-server 2>/dev/null; then 
    echo -e "${Vert}✅ MariaDB-server est déjà installé${NC}"
else
    echo "📦 Installation de MariaDB-server en cours..."
    nala install -y mariadb-server
fi

##Installation des extensions php-xml php-common php-json php-mysql php-mbstring php-curl php-gd php-intl php-zip php-bz2 php-imap php-apcu
#Verif php-xml
if dpkg -l | grep php-xml 2>/dev/null; then 
    echo -e "${Vert}✅ php-xml est déjà installé${NC}"
else
    echo "📦 Installation de php-xml en cours..."
    nala install -y php-xml
fi
#Verif php-common
if dpkg -l | grep php-common 2>/dev/null; then 
    echo -e "${Vert}✅ php-common est déjà installé${NC}"
else
    echo "📦 Installation de php-common en cours..."
    nala install -y php-common
fi
#Verif php-json
if dpkg -l | grep php-json 2>/dev/null; then 
    echo -e "${Vert}✅ php-json est déjà installé${NC}"
else
    echo "📦 Installation de php-json en cours..."
    nala install -y php-json
fi
#Verif php-mysql
if dpkg -l | grep php-mysql 2>/dev/null; then 
    echo -e "${Vert}✅ php-mysql est déjà installé${NC}"
else
    echo "📦 Installation de php-mysql en cours..."
    nala install -y php-mysql
fi
#Verif php-mbstring
if dpkg -l | grep php-mbstring 2>/dev/null; then 
    echo -e "${Vert}✅ php-mbstring est déjà installé${NC}"
else
    echo "📦 Installation de php-mbstring en cours..."
    nala install -y php-mbstring
fi
#Verif php-curl
if dpkg -l | grep php-curl 2>/dev/null; then 
    echo -e "${Vert}✅ php-curl est déjà installé${NC}"
else
    echo "📦 Installation de php-curl en cours..."
    nala install -y php-curl
fi
#Verif php-gd
if dpkg -l | grep php-gd 2>/dev/null; then 
    echo -e "${Vert}✅ php-gd est déjà installé${NC}"
else
    echo "📦 Installation de php-gd en cours..."
    nala install -y php-gd
fi
#Verif php-intl
if dpkg -l | grep php-intl 2>/dev/null; then 
    echo -e "${Vert}✅ php-intl est déjà installé${NC}"
else
    echo "📦 Installation de php-intl en cours..."
    nala install -y php-intl
fi
#Verif php-zip
if dpkg -l | grep php-zip 2>/dev/null; then 
    echo -e "${Vert}✅ php-zip est déjà installé${NC}"
else
    echo "📦 Installation de php-zip en cours..."
    nala install -y php-zip
fi
#Verif php-bz2
if dpkg -l | grep php-bz2 2>/dev/null; then 
    echo -e "${Vert}✅ php-bz2 est déjà installé${NC}"
else
    echo "📦 Installation de php-bz2 en cours..."
    nala install -y php-bz2
fi
#Verif php-imap
if dpkg -l | grep php-imap 2>/dev/null; then 
    echo -e "${Vert}✅ php-imap est déjà installé${NC}"
else
    echo "📦 Installation de php-imap en cours..."
    nala install -y php-imap
fi
#Verif php-apcu
if dpkg -l | grep php-apcu 2>/dev/null; then 
    echo -e "${Vert}✅ php-apcu est déjà installé${NC}"
else
    echo "📦 Installation de php-apcu en cours..."
    nala install -y php-apcu
fi
#Verif php8.2-fpm
if dpkg -l | grep php8.2-fpm 2>/dev/null; then 
    echo "${Vert}✅ php8.2-fpm est déjà installé${NC}"
else
    echo "📦 Installation de php8.2-fpm en cours..."
    nala install -y php8.2-fpm
fi
##Demande si le module PHP-LDAP est voulu 
read -p "$(echo -e "${Question}Voulez-vous installer le module PHP-LDAP qui permettera à l'avenir de relier votre GLPI à votre Active-Directory ?${NC}")" phpldap_install
case $phpldap_install in
    oui|o|Oui|yes|y|Yes)
        #Vérif présence paquet php-ldap
        if dpkg -l | grep php-ldap 2>/dev/null; then 
            echo -e "${Vert}✅ php-ldap est déjà installé${NC}"
        else 
            echo "📦 Installation de php-ldap en cours..."
            nala install -y php-ldap
        fi
        ;;
    non|n|Non|no|No)
        echo "Ok, pas de soucis, je n'installe pas php-ldap"
        ;;
esac

#Création de la base de donnée de GLPI
read -p "$(echo -e "${Question}Défini un mot de passe pour ta base de donnée db23_glpi ${NC}(faites entrée sur la prochaine question) : ")" mdp_db23glpi
echo "🔧 Configuration de la base de donnée pour GLPI en cours..."
mysql -u root -p <<EOF
CREATE DATABASE db23_glpi;
GRANT ALL PRIVILEGES ON db23_glpi.* TO glpi_adm@localhost IDENTIFIED BY "${mdp_db23glpi}";
FLUSH PRIVILEGES;
EOF
echo -e "${Vert}✅ MySQL a été configuré avec succès 🥳​!${NC}"

#Installation des fichiers de glpi 
cd /tmp
wget https://github.com/glpi-project/glpi/releases/download/10.0.18/glpi-10.0.18.tgz
tar -xzvf glpi-10.0.18.tgz -C /var/www/
chown www-data /var/www/glpi/ -R

#Création des repertoires & fichier pour GLPI
mkdir /etc/glpi
chown www-data /etc/glpi/
mv /var/www/glpi/config /etc/glpi
mkdir /var/lib/glpi
chown www-data /var/lib/glpi/
mv /var/www/glpi/files /var/lib/glpi
mkdir /var/log/glpi
chown www-data /var/log/glpi

read -p "$(echo -e "${Question}Quel sera l'URL de votre GLPI ? (ex: glpi.lebgdu44.lan)${NC} :")" url_glpi

touch /var/www/glpi/inc/downstream.php
echo "fichier downstream created"
cat > /var/www/glpi/inc/downstream.php <<EOF
<?php
define('GLPI_CONFIG_DIR', '/etc/glpi/');
if (file_exists(GLPI_CONFIG_DIR . '/local_define.php')) {
    require_once GLPI_CONFIG_DIR . '/local_define.php';
}
EOF
echo "fichier downstream modif"
touch /etc/glpi/local_define.php
echo "fichier lan define created"
cat > /etc/glpi/local_define.php <<EOF 
<?php
define('GLPI_VAR_DIR', '/var/lib/glpi/files');
define('GLPI_LOG_DIR', '/var/log/glpi');
EOF
echo "fichier lan define modif"
touch /etc/apache2/sites-available/${url_glpi}.conf
cat > /etc/apache2/sites-available/${url_glpi}.conf <<EOF
<VirtualHost *:80>
    ServerName ${url_glpi}

    DocumentRoot /var/www/glpi/public

    # If you want to place GLPI in a subfolder of your site (e.g. your virtual host is serving multiple applications),
    # you can use an Alias directive. If you do this, the DocumentRoot directive MUST NOT target the GLPI directory itself.
    # Alias "/glpi" "/var/www/glpi/public"

    <Directory /var/www/glpi/public>
        Require all granted

        RewriteEngine On

        # Redirect all requests to GLPI router, unless file exists.
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteRule ^(.*)$ index.php [QSA,L]
    </Directory>
    <FilesMatch \.php$>
        SetHandler "proxy:unix:/run/php/php8.2-fpm.sock|fcgi://localhost/"
    </FilesMatch>
</VirtualHost>
EOF
echo "fichier apache modif " 
#Publication de GLPI 
a2ensite ${url_glpi}.conf
echo -e "${Vert}✅ Le site ${url_glpi} a bien été publié 🥳 !!! ${NC} "
a2dissite 000-default.conf
a2enmod rewrite
systemctl restart apache2


a2enmod proxy_fcgi setenvif
a2enconf php8.2-fpm
systemctl reload apache2

sed -i 's/^session\.cookie_httponly *=.*/session.cookie_httponly = on/' /etc/php/8.2/fpm/php.ini
systemctl restart php8.2-fpm.service
systemctl restart apache2

## Dicte les consignes de connexion à la BD depuis l'interface de configuration web de GLPI
echo -e "${Cyansoul}Voici les informations de connexion à la base de donnée de GLPI${NC}"
echo -e "${Cyansoul}Serveur SQL :${NC}${Cyan} localhost${NC}"
echo -e "${Cyansoul}Utilisateur SQL :${NC}${Cyan} db23_glpi${NC}"
echo -e "${Cyansoul}Mot de passe SQL :${NC}${Cyan} ${mdp_db23glpi} ${NC}"