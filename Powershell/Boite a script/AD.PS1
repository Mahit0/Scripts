##################################################
# Author : Mattéo AUBRY                          #
# Date : 18/02/2025                              #
# Description : Boite a script de Matt (AD)      #
# Version : 1.0                                  #
# Name : ad.ps1                                  #
##################################################

# Formulaire - Création du canva
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Recherche de fichiers"
$Form.Width = 500
$Form.Height = 200
$Form.AutoSize = $true

# Afficher la GUI
$Form.ShowDialog()


Import-Module ActiveDirectory

Write-Host "----------------------Scripts ActiveDirectory----------------------" -ForegroundColor Blue
Write-Host "1 - Creer un utilisateur" -ForegroundColor Blue
Write-Host "2 - Verifier qui fait parti d'un groupe" -ForegroundColor Blue
Write-Host "3 - Creer un groupe " -ForegroundColor Blue
Write-Host "4 - Supprimer un groupe" -ForegroundColor Blue
Write-Host "5 - Ajouter un utilisateur à un groupe" -ForegroundColor Blue
Write-Host "6 - Supprimer un utilisateur d'un groupe" -ForegroundColor Blue
Write-Host "7 - Modifier le mot de passe d'un utilisateur" -ForegroundColor Blue
Write-Host "8 - Desactiver un utilisateur"  -ForegroundColor Blue
Write-Host "9 - Verification de la derniere connexion d'un utilisateur" -ForegroundColor Blue
Write-Host "10 - Listing des ordinateurs present dans l'AD " -ForegroundColor Blue
Write-Host "11 - Listing des utilisateurs presents dans l'AD" -ForegroundColor Blue
Write-Host "12 - Listing des groupes presents dans l'AD" -ForegroundColor Blue
Write-Host "--------------------------------------------------------------------" -ForegroundColor Blue
$choix = Read-Host "Que veux-tu faire ?"

switch ($choix) {
    1 {
       <# $username = Read-Host "Entre le nom de l'utilisateur"
        $name = Read-Host "Entre le prénom de l'utilisateur"
        $fullname = Read-Host "Entre le nom de famille de l'utilisateur"
        $password = Read-Host "Entre le mot de passe de l'utilisateur" -AsSecureString

        $user = New-ADUser -Name $username `
            -DisplayName $usernmae `
            -GiveneName $name `
            -Surname $fullname `
            -SamAccountName $username `
            -AccountPassword $password `
            -ChangePasswordAtLogon $true `
            -Enable $true `
        
        $domain = Get-ADDOmain | Select-Object DistinguishedName
        $ou = Get-ADOrgasnizationalUnit -Filter * | Where { $_.DistinguishedName -like "*$($domain.DistinguishedName)" } | Select-Object DistinguishedName
        #>

    }
    2 {
        Add-Type -AssemblyName System.Windows.Forms
        
        $Form = New-Object System.Windows.Forms.Form
        $Form.Text = "Active Directory - Computer Infos - $((Get-ADDomain).DNSRoot)"
        $Form.Width = 500
        $Form.Height = 150
        $Form.AutoSize = $true
        
        $ButtonCheck = New-Object System.Windows.Forms.Button
        $ButtonCheck.Location = New-Object System.Drawing.Size(10,80)
        $ButtonCheck.Size = New-Object System.Drawing.Size(100,25)
        $ButtonCheck.Text = "Vérifier"
        $ButtonCheck.Visible = $true
        $Form.Controls.Add($ButtonCheck)
        
        $LabelSelectUser = New-Object System.Windows.Forms.Label
        $LabelSelectUser.Text = "Sélectionner un Groupe"
        $LabelSelectUser.Location = New-Object System.Drawing.Point(10,12)
        $LabelSelectUser.AutoSize = $true
        $LabelSelectUser.Visible = $true
        $Form.Controls.Add($LabelSelectUser)
        
        $ComboBoxUserList = New-Object System.Windows.Forms.ComboBox
        $ComboBoxUserList.Width = 150
        $ComboBoxUserList.Visible = $true
        $ComboBoxUserList.Location  = New-Object System.Drawing.Point(150,10)
        $Form.Controls.Add($ComboBoxUserList)
        
        $Label = New-Object System.Windows.Forms.Label
        $Label.Text = ""
        $Label.Location = New-Object System.Drawing.Point(10,40)
        $Label.AutoSize = $true
        $Label.Visible = $true
        $Label.ForeColor = "green"
        $Form.Controls.Add($Label)
    }
    3 {
        # Code pour créer un groupe
    }
    4 {
        # Code pour supprimer un groupe
    }
    5 {
        # Code pour ajouter un utilisateur à un groupe
    }
    6 {
        # Code pour supprimer un utilisateur d'un groupe
    }
    7 {
        # Code pour modifier le mot de passe d'un utilisateur
    }
    8 {
        # Code pour désactiver un utilisateur
    }
    9 {
        function Get-ADUserLastLogon {
            [CmdletBinding()]
            param(
                [Parameter(Mandatory=$true)][ValidateScript({Get-ADUser $_})]$Identity=$null
            )
        
            $DCList = Get-ADDomainController -Filter * | Sort-Object Name | Select-Object -ExpandProperty Name
            $TargetUserLastLogon = $null
        
            foreach ($DCName in $DCList) {
                try {
                    $LastLogonDC = Get-ADUser -Identity $Identity -Properties lastLogon -Server $DCName
                    $LastLogon = [Datetime]::FromFileTime($LastLogonDC.lastLogon)
                    if ($LastLogon -gt $TargetUserLastLogon) {
                        $TargetUserLastLogon = $LastLogon
                    }
                } catch {
                    Write-Host $_.Exception.Message -ForegroundColor Red
                }
            }
        
            return $TargetUserLastLogon
        }
        
        Add-Type -AssemblyName System.Windows.Forms
        
        $Form = New-Object System.Windows.Forms.Form
        $Form.Text = "Active Directory - LastLogon - $((Get-ADDomain).DNSRoot)"
        $Form.Width = 500
        $Form.Height = 150
        $Form.AutoSize = $true
        
        $ButtonCheck = New-Object System.Windows.Forms.Button
        $ButtonCheck.Location = New-Object System.Drawing.Size(10,80)
        $ButtonCheck.Size = New-Object System.Drawing.Size(100,25)
        $ButtonCheck.Text = "Vérifier"
        $ButtonCheck.Visible = $true
        $Form.Controls.Add($ButtonCheck)
        
        $LabelSelectUser = New-Object System.Windows.Forms.Label
        $LabelSelectUser.Text = "Sélectionner un utilisateur"
        $LabelSelectUser.Location = New-Object System.Drawing.Point(10,12)
        $LabelSelectUser.AutoSize = $true
        $LabelSelectUser.Visible = $true
        $Form.Controls.Add($LabelSelectUser)
        
        $ComboBoxUserList = New-Object System.Windows.Forms.ComboBox
        $ComboBoxUserList.Width = 150
        $ComboBoxUserList.Visible = $true
        $ComboBoxUserList.Location  = New-Object System.Drawing.Point(150,10)
        $Form.Controls.Add($ComboBoxUserList)
        
        $Label = New-Object System.Windows.Forms.Label
        $Label.Text = ""
        $Label.Location = New-Object System.Drawing.Point(10,40)
        $Label.AutoSize = $true
        $Label.Visible = $true
        $Label.ForeColor = "green"
        $Form.Controls.Add($Label)
        
        Get-ADUser -Filter {Enabled -eq $true} | Select-Object -ExpandProperty SamAccountName | ForEach-Object {
            $ComboBoxUserList.Items.Add($_)
        }
        
        $ButtonCheck.Add_Click({
            if ($ComboBoxUserList.SelectedItem -ne $null) {
                $LastLogonOfUser = Get-ADUserLastLogon -Identity $ComboBoxUserList.SelectedItem
                $Label.Text = "Dernière connexion de $($ComboBoxUserList.SelectedItem) : $LastLogonOfUser"
            } else {
                [System.Windows.Forms.MessageBox]::Show("Vous devez sélectionner un utilisateur !", "Erreur - $((Get-ADDomain).DNSRoot)", 0, 16)
            }
        })
        
        $Form.ShowDialog()
    }
    10 {
        # Code pour lister les ordinateurs présents dans l'AD
    }
    11 {
        # Code pour lister les utilisateurs présents dans l'AD
    }
    12 {
        # Code pour lister les groupes présents dans l'AD
    }
}
