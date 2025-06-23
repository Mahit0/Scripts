##################################################
# Author : Mattéo AUBRY                          #
# Date : 18/02/2025                              #
# Description : Boite a script de Matt (lan)     #
# Version : 1.0                                  #
# Name : lan.ps1                                 #
##################################################

Add-Type -AssemblyName System.Windows.Forms

Write-Host "----------------------Scripts LAN-----------------------------------" -ForegroundColor Blue
Write-Host "1 - Creer un utilisateur" -ForegroundColor Blue
Write-Host "2 - Verifier qui fait parti d'un groupe" -ForegroundColor Blue
Write-Host "3 - Creer un groupe " -ForegroundColor Blue
Write-Host "4 - Supprimer un groupe" -ForegroundColor Blue
Write-Host "5 - Ajouter un utilisateur à un groupe" -ForegroundColor Blue
Write-Host "6 - Supprimer un utilisateur d'un groupe" -ForegroundColor Blue
Write-Host "7 - Modifier le mot de passe d'un utilisateur" -ForegroundColor Blue
Write-Host "8 - Desactiver un utilisateur"  -ForegroundColor Blue
Write-Host "9 - Verification de la derniere connexion d'un utilisateur" -ForegroundColor Blue
Write-Host "--------------------------------------------------------------------" -ForegroundColor Blue
$choix = Read-Host "Que veux-tu faire ?"

switch ($choix) {
    1 {
        $prenom = Read-Host "Entre le prenom de l'utilisateur"
        $nom = Read-Host "Entre le nom de l'utilisateur"
        $username = $prenom[0]+$nom
        $password = Read-Host "Entre le mot de passe de l'utilisateur" -AsSecureString

        if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
            Write-Host "L'utilisateur existe déjà" -ForegroundColor Red
            [System.Windows.forms.MessageBox]::Show("L'utilisateur existe déjà boloss va...","Utilisateur deja existant",0,16)
        } else {
            New-LocalUser -Name $username -Password $password -FullName "$prenom $nom" -Description "Compte utilisateur"
            [System.Windows.forms.MessageBox]::Show("Bien joué frero, ton utilisateur a été crée ;)","Utilisateur cree",0,64)
        } 
    }
    2 {
        $group = Read-Host "Entre le nom du groupe"
        $user = Read-Host "Entre le nom de l'utilisateur"
        if (Get-LocalGroupMember -Group $group -Member $user -ErrorAction SilentlyContinue) {
            Write-Host "$user fait partie du groupe $group" -ForegroundColor Green
        } else {
            Write-Host "$user ne fait pas partie du groupe $group" -ForegroundColor Red
        }
    }
}