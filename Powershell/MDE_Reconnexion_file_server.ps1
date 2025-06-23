################################################################################
# Author : Mattéo AUBRY                                                        #
# Name : MDE_Reconnexion_file_server.ps1                                       #
# Description : Reconnexion lecteur reseau quand impossible de s'y connecter   #
# Version : 1.0                                                                #
# Date : 18/03/2025                                                            #
################################################################################

#Garde en mémoire dans la variable $path le chemin vers data 
$path = "\\DOM02.Astorya.fr\Données\11_Répertoire_Personnel_Salariés\m.aubrybodinier"

#Retire le lecteur réseau 
Remove-SmbMapping -RemotePath $path -force

#Rajoute le lecteur réseau 
New-SmbMapping -LocalPath "U:" -RemotePath $path






