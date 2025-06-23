Import-Module ActiveDirectory
$name = Read-Host -Prompt "Prénom"
$nomfamille = Read-Host -Prompt "Nom de famille"
$username = $name.Substring(0,1) + $nomfamille

if (Get-ADUser -Filter {SamAccountName -eq $username}) {
    Write-Warning "L'identifiant $username existe déjà dans l'AD, boloss va"
} else {
    $password = Read-Host -Prompt "Mot de passe" -AsSecureString

    $continue = $true
    while ($continue) {
        Write-Host "--------------Choix de l'agence--------------" -ForegroundColor Red
        Write-Host "1. Nantes" -ForegroundColor Red
        Write-Host "2. Vertou" -ForegroundColor Red
        Write-Host "3. Rennes" -ForegroundColor Red
        Write-Host "x. exit" -ForegroundColor Red
        Write-Host "---------------------------------------------" -ForegroundColor Red
        $choix1 = Read-Host "Faites un choix :"
        switch ($choix1) {
            1 {
                while ($continue) {
                    Write-Host "--------------Choix du poste--------------" -ForegroundColor Gray
                    Write-Host "1. Salarié" -ForegroundColor Gray
                    Write-Host "2. Secrétaire" -ForegroundColor Gray
                    Write-Host "x. exit" -ForegroundColor Gray
                    Write-Host "------------------------------------------" -ForegroundColor Gray
                    $choix2 = Read-Host "Faites un choix"
                    switch ($choix2) {
                        1 {
                            $targetOU = "OU=Salariés,OU=Utilisateurs,OU=Informatique,OU=Nantes,OU=Agence,OU=_TP4,DC=Matteo,DC=lcl"
                            $groupName = "NTS_GG_Informatique"
                            # Création de l'utilisateur
                                        $user = New-ADUser -Name $username `
                                            -DisplayName $username `
                                            -GivenName $name `
                                            -Surname $nomfamille `
                                            -SamAccountName $username `
                                            -AccountPassword $password `
                                            -ChangePasswordAtLogon $true `
                                            -Enable $true `
                                            -PassThru

                                        # Déplacement et ajout aux groupes
                                        Move-ADObject -Identity $user.DistinguishedName -TargetPath $targetOU
                                        Add-ADGroupMember -Identity $groupName -Members $user.SamAccountName
                                        Add-ADGroupMember -Identity $groupName2 -Members $user.SamAccountName

                                        Write-Host "Création de l'utilisateur pour $name $nomfamille : $username" -ForegroundColor Cyan
                                        $continue = $false
                            
                        }
                        2 {
                            $targetOU = "OU=Secrétaires,OU=Utilisateurs,OU=Informatique,OU=Nantes,OU=Agence,OU=_TP4,DC=Matteo,DC=lcl"
                            $groupName = "NTS_GG_Secretaire"
                            # Création de l'utilisateur
                                        $user = New-ADUser -Name $username `
                                            -DisplayName $username `
                                            -GivenName $name `
                                            -Surname $nomfamille `
                                            -SamAccountName $username `
                                            -AccountPassword $password `
                                            -ChangePasswordAtLogon $true `
                                            -Enable $true `
                                            -PassThru

                                        # Déplacement et ajout aux groupes
                                        Move-ADObject -Identity $user.DistinguishedName -TargetPath $targetOU
                                        Add-ADGroupMember -Identity $groupName -Members $user.SamAccountName
                                        Add-ADGroupMember -Identity $groupName2 -Members $user.SamAccountName

                                        Write-Host "Création de l'utilisateur pour $name $nomfamille : $username" -ForegroundColor Cyan
                                        $continue = $false
                        }
                        'x' {
                            $continue = $false
                            break
                        }
                        default {
                            Write-Host "Choix invalide" -ForegroundColor Red
                            continue
                        }
                    }

                    
                }
            }
            2 {
                while ($continue) {
                    Write-Host "--------------Choix du poste--------------" -ForegroundColor Gray
                    Write-Host "1. Salarié" -ForegroundColor Gray
                    Write-Host "2. Intérimaire" -ForegroundColor Gray
                    Write-Host "x. exit" -ForegroundColor Gray
                    Write-Host "------------------------------------------" -ForegroundColor Gray
                    $choix3 = Read-Host "Faites un choix"
                    switch ($choix3) {
                        1 {
                            while ($continue) {
                                Write-Host "--------------Choix des horaires--------------" -ForegroundColor Green
                                Write-Host "1. 6h - 13h" -ForegroundColor Green
                                Write-Host "2. 13h - 21h" -ForegroundColor Green
                                Write-Host "x. exit" -ForegroundColor Green
                                Write-Host "-----------------------------------------------" -ForegroundColor Green
                                $choix4 = Read-Host "Faites un choix"
                                switch ($choix4) {
                                    1 {
                                        $targetOU = "OU=Matin,OU=Salariés,OU=Utilisateurs,OU=Production,OU=Vertou,OU=Agence,OU=_TP4,DC=Matteo,DC=lcl"
                                        $groupName = "VRT_GG_Prod_Matin"
                                        $groupName2 = "VRT_GG_Production"
                                        # Création de l'utilisateur
                                        $user = New-ADUser -Name $username `
                                            -DisplayName $username `
                                            -GivenName $name `
                                            -Surname $nomfamille `
                                            -SamAccountName $username `
                                            -AccountPassword $password `
                                            -ChangePasswordAtLogon $true `
                                            -Enable $true `
                                            -PassThru

                                        # Déplacement et ajout aux groupes
                                        Move-ADObject -Identity $user.DistinguishedName -TargetPath $targetOU
                                        Add-ADGroupMember -Identity $groupName -Members $user.SamAccountName
                                        Add-ADGroupMember -Identity $groupName2 -Members $user.SamAccountName

                                        Write-Host "Création de l'utilisateur pour $name $nomfamille : $username" -ForegroundColor Cyan
                                        $continue = $false
                                    }
                                    2 {
                                        $targetOU = "OU=Après-Midi,OU=Salariés,OU=Utilisateurs,OU=Production,OU=Vertou,OU=Agence,OU=_TP4,DC=Matteo,DC=lcl"
                                        $groupName = "VRT_GG_Prod_Aprem"
                                        $groupName2 = "VRT_GG_Production"
                                        # Création de l'utilisateur
                                        $user = New-ADUser -Name $username `
                                            -DisplayName $username `
                                            -GivenName $name `
                                            -Surname $nomfamille `
                                            -SamAccountName $username `
                                            -AccountPassword $password `
                                            -ChangePasswordAtLogon $true `
                                            -Enable $true `
                                            -PassThru

                                        # Déplacement et ajout aux groupes
                                        Move-ADObject -Identity $user.DistinguishedName -TargetPath $targetOU
                                        Add-ADGroupMember -Identity $groupName -Members $user.SamAccountName
                                        Add-ADGroupMember -Identity $groupName2 -Members $user.SamAccountName

                                        Write-Host "Création de l'utilisateur pour $name $nomfamille : $username" -ForegroundColor Cyan
                                $continue = $false
                                    }
                                    'x' {
                                        $continue = $false
                                        break
                                    }
                                    default {
                                        Write-Host "Choix invalide" -ForegroundColor Red
                                        continue
                                    }
                                }

                               
                            }
                        }
                        2 {
                            while ($continue) {
                                Write-Host "--------------Choix des horaires--------------" -ForegroundColor Green
                                Write-Host "1. 6h - 13h" -ForegroundColor Green
                                Write-Host "2. 13h - 21h" -ForegroundColor Green
                                Write-Host "x. exit" -ForegroundColor Green
                                Write-Host "-----------------------------------------------" -ForegroundColor Green
                                $choix5 = Read-Host "Faites un choix"
                                switch ($choix5) {
                                    1 {
                                        $targetOU = "OU=Matin,OU=Intérimaires,OU=Utilisateurs,OU=Production,OU=Vertou,OU=Agence,OU=_TP4,DC=Matteo,DC=lcl"
                                        $groupName = "VRT_GG_Prod_Matin"
                                        $groupName2 = "VRT_GG_Production"
                                        # Création de l'utilisateur
                                        $user = New-ADUser -Name $username `
                                            -DisplayName $username `
                                            -GivenName $name `
                                            -Surname $nomfamille `
                                            -SamAccountName $username `
                                            -AccountPassword $password `
                                            -ChangePasswordAtLogon $true `
                                            -Enable $true `
                                            -PassThru

                                        # Déplacement et ajout aux groupes
                                        Move-ADObject -Identity $user.DistinguishedName -TargetPath $targetOU
                                        Add-ADGroupMember -Identity $groupName -Members $user.SamAccountName
                                        Add-ADGroupMember -Identity $groupName2 -Members $user.SamAccountName

                                        Write-Host "Création de l'utilisateur pour $name $nomfamille : $username" -ForegroundColor Cyan
                                        $continue = $false
                                    }
                                    2 {
                                        $targetOU = "OU=Après-Midi,OU=Intérimaires,OU=Utilisateurs,OU=Production,OU=Vertou,OU=Agence,OU=_TP4,DC=Matteo,DC=lcl"
                                        $groupName = "VRT_GG_Prod_Aprem"
                                        $groupName2 = "VRT_GG_Production"
                                        # Création de l'utilisateur
                                        $user = New-ADUser -Name $username `
                                            -DisplayName $username `
                                            -GivenName $name `
                                            -Surname $nomfamille `
                                            -SamAccountName $username `
                                            -AccountPassword $password `
                                            -ChangePasswordAtLogon $true `
                                            -Enable $true `
                                            -PassThru

                                        # Déplacement et ajout aux groupes
                                        Move-ADObject -Identity $user.DistinguishedName -TargetPath $targetOU
                                        Add-ADGroupMember -Identity $groupName -Members $user.SamAccountName
                                        Add-ADGroupMember -Identity $groupName2 -Members $user.SamAccountName

                                        Write-Host "Création de l'utilisateur pour $name $nomfamille : $username" -ForegroundColor Cyan
                                         $continue = $false
                                    }
                                    'x' {
                                        $continue = $false
                                        break
                                    }
                                    default {
                                        Write-Host "Choix invalide" -ForegroundColor Red
                                        continue
                                    }
                                }

                                
                            }
                        }
                        'x' {
                            $continue = $false
                            break
                        }
                        default {
                            Write-Host "Choix invalide" -ForegroundColor Red
                        }
                    }
                }
            }
            3 {
                while ($continue) {
                    Write-Host "--------------Choix du poste--------------" -ForegroundColor Gray
                    Write-Host "1. Salarié" -ForegroundColor Gray
                    Write-Host "2. Intérimaire" -ForegroundColor Gray
                    Write-Host "3. Secrétaires" -ForegroundColor Gray
                    Write-Host "x. exit" -ForegroundColor Gray
                    Write-Host "------------------------------------------" -ForegroundColor Gray
                    $choix6 = Read-Host "Faites un choix :"
                    switch ($choix6) {
                        1 {
                            $targetOU = "OU=Salariés,OU=Utilisateurs,OU=Informatique,OU=Rennes,OU=Agence,OU=_TP4,DC=Matteo,DC=lcl"
                            $groupName = "REN_GG_Informatique"
                            $user = New-ADUser -Name $username `
                                -DisplayName $username `
                                -GivenName $name `
                                -Surname $nomfamille `
                                -SamAccountName $username `
                                -AccountPassword $password `
                                -ChangePasswordAtLogon $true `
                                -Enable $true `
                                -PassThru

                            # Ajout de l'utilisateur au groupe
                            Add-ADGroupMember -Identity $groupName -Members $user.SamAccountName

                            # Déplacement de l'utilisateur dans l'OU appropriée
                            Move-ADObject -Identity $user.DistinguishedName -TargetPath $targetOU

                            Write-Host "Création de l'utilisateur pour $name $nomfamille : $username" -ForegroundColor Cyan
                            $continue = $false
                        }
                        }
                        2 {
                            $targetOU = "OU=Intérimaires,OU=Utilisateurs,OU=Informatique,OU=Rennes,OU=Agence,OU=_TP4,DC=Matteo,DC=lcl"
                            $groupName = "REN_GG_Interimaires"
                            $user = New-ADUser -Name $username `
                                -DisplayName $username `
                                -GivenName $name `
                                -Surname $nomfamille `
                                -SamAccountName $username `
                                -AccountPassword $password `
                                -ChangePasswordAtLogon $true `
                                -Enable $true `
                                -PassThru

                            # Ajout de l'utilisateur au groupe
                            Add-ADGroupMember -Identity $groupName -Members $user.SamAccountName

                            # Déplacement de l'utilisateur dans l'OU appropriée
                            Move-ADObject -Identity $user.DistinguishedName -TargetPath $targetOU

                            Write-Host "Création de l'utilisateur pour $name $nomfamille : $username" -ForegroundColor Cyan
                            $continue = $false
                        }
                        }
                        3  {
                            $targetOU = "OU=Secrétaires,OU=Utilisateurs,OU=Informatique,OU=Rennes,OU=Agence,OU=_TP4,DC=Matteo,DC=lcl"
                            $groupName = "REN_GG_Secretaire" 
                            $user = New-ADUser -Name $username `
                                -DisplayName $username `
                                -GivenName $name `
                                -Surname $nomfamille `
                                -SamAccountName $username `
                                -AccountPassword $password `
                                -ChangePasswordAtLogon $true `
                                -Enable $true `
                                -PassThru

                             # Ajout de l'utilisateur au groupe
                            Add-ADGroupMember -Identity $groupName -Members $user.SamAccountName

                            # Déplacement de l'utilisateur dans l'OU appropriée
                            Move-ADObject -Identity $user.DistinguishedName -TargetPath $targetOU

                            Write-Host "Création de l'utilisateur pour $name $nomfamille : $username" -ForegroundColor Cyan
                            $continue = $false
                            }
                        }
                        'x' {
                            $continue = $false
                            break
                        }
                        default {
                            Write-Host "Choix invalide" -ForegroundColor Red
                            continue
                        }
                    }

                    
                }
            }
            'x' {
                $continue = $false
            }
            default {
                Write-Host "Choix invalide" -ForegroundColor Red
            }
        }
    }
}
