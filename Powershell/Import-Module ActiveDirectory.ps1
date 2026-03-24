Import-Module ActiveDirectory

$domain = Get-ADDomain
$baseDN = $domain.DistinguishedName

# NOUVEAU : supprime les accents pour le SamAccountName
function Remove-Accents {
    param([string]$str)
    $normalized = $str.Normalize([System.Text.NormalizationForm]::FormD)
    $sb = [System.Text.StringBuilder]::new()
    foreach ($c in $normalized.ToCharArray()) {
        $cat = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($c)
        if ($cat -ne [System.Globalization.UnicodeCategory]::NonSpacingMark) {
            [void]$sb.Append($c)
        }
    }
    return $sb.ToString()
}

function CreaUser {
    $script:name       = Read-Host -Prompt "Prenom"
    $script:nomfamille = Read-Host -Prompt "Nom de famille"
    # FIXE : on passe par Remove-Accents avant de construire le username
    $script:username   = (Remove-Accents $script:name).Substring(0,1).ToLower() + (Remove-Accents $script:nomfamille).ToLower()
    $script:password   = "Pa$$w0rd"
}

function New-UtilisateurAD {
    param(
        [string]$TargetOU,
        [string]$GroupName
    )

    CreaUser

    try {
        Get-ADGroup -Identity $GroupName | Out-Null
    } catch {
        Write-Host "ERREUR : le groupe '$GroupName' n'existe pas. Cree-le d'abord." -ForegroundColor Red
        return
    }

    $user = New-ADUser `
        -Name                  "$($script:name) $($script:nomfamille)" `
        -DisplayName           "$($script:name) $($script:nomfamille)" `
        -GivenName             $script:name `
        -Surname               $script:nomfamille `
        -SamAccountName        $script:username `
        -AccountPassword       $script:password `
        -ChangePasswordAtLogon $true `
        -Enabled               $true `
        -Path                  $TargetOU `
        -PassThru

    Add-ADGroupMember -Identity $GroupName -Members $user.SamAccountName

    Write-Host "Utilisateur $($script:name) $($script:nomfamille) ($($script:username)) cree." -ForegroundColor Cyan
}

do {
    Write-Host "=================== Menu principal ==================="
    Write-Host "1 - Creation d'OU"
    Write-Host "2 - Creation d'utilisateur"
    Write-Host "x - Quitter"
    Write-Host "======================================================"
    $choix = Read-Host "Ton choix"

    switch ($choix) {

        "1" {
            do {
                Write-Host "=================== Menu des OU ==================="
                Write-Host "1 - Creer toute la structure d'un coup"
                Write-Host "2 - Creer une OU Niveau 1 (Usine / Service)"
                Write-Host "3 - Creer une OU Niveau 2 (Type d'objet)"
                Write-Host "4 - Creer une OU Niveau 3 (Service utilisateurs)"
                Write-Host "x - Retour"
                Write-Host "==================================================="
                $choixOU = Read-Host "Ton choix"

                switch ($choixOU) {
                    "1" {
                        foreach ($aff in @("Usine", "Service")) {
                            New-ADOrganizationalUnit -Name $aff -Path $baseDN -ErrorAction SilentlyContinue
                            foreach ($type in @("Utilisateurs", "Groupes", "Stations de travail", "Serveurs")) {
                                New-ADOrganizationalUnit -Name $type -Path "OU=$aff,$baseDN" -ErrorAction SilentlyContinue
                                if ($type -eq "Utilisateurs") {
                                    foreach ($svc in @("Production", "Comptabilite", "Commercial", "Ressources Humaines", "Informatique", "Direction")) {
                                        New-ADOrganizationalUnit -Name $svc -Path "OU=Utilisateurs,OU=$aff,$baseDN" -ErrorAction SilentlyContinue
                                    }
                                }
                            }
                        }
                        Write-Host "Structure complete creee !" -ForegroundColor Green
                    }

                    "2" {
                        Write-Host "1 - Usine"
                        Write-Host "2 - Service"
                        $c = Read-Host "Ton choix"
                        if ($c -eq "1") { $aff = "Usine" } else { $aff = "Service" }
                        New-ADOrganizationalUnit -Name $aff -Path $baseDN -ErrorAction SilentlyContinue
                        Write-Host "OU '$aff' creee." -ForegroundColor Green
                    }

                    "3" {
                        Write-Host "1 - Usine"
                        Write-Host "2 - Service"
                        $c = Read-Host "Dans quelle affectation"
                        if ($c -eq "1") { $aff = "Usine" } else { $aff = "Service" }

                        Write-Host "1 - Utilisateurs"
                        Write-Host "2 - Groupes"
                        Write-Host "3 - Stations de travail"
                        Write-Host "4 - Serveurs"
                        $c = Read-Host "Quel type"
                        switch ($c) {
                            "1" { $type = "Utilisateurs" }
                            "2" { $type = "Groupes" }
                            "3" { $type = "Stations de travail" }
                            "4" { $type = "Serveurs" }
                            # FIXE : default manquant, on skippe si valeur invalide
                            default {
                                Write-Host "Choix invalide." -ForegroundColor Red
                                $type = $null
                            }
                        }
                        if ($type) {
                            New-ADOrganizationalUnit -Name $type -Path "OU=$aff,$baseDN" -ErrorAction SilentlyContinue
                            Write-Host "OU '$type' creee sous '$aff'." -ForegroundColor Green
                        }
                    }

                    "4" {
                        Write-Host "1 - Usine"
                        Write-Host "2 - Service"
                        $c = Read-Host "Dans quelle affectation"
                        if ($c -eq "1") { $aff = "Usine" } else { $aff = "Service" }

                        Write-Host "1 - Production"
                        Write-Host "2 - Comptabilite"
                        Write-Host "3 - Commercial"
                        Write-Host "4 - Ressources Humaines"
                        Write-Host "5 - Informatique"
                        Write-Host "6 - Direction"
                        $c = Read-Host "Quel service"
                        switch ($c) {
                            "1" { $svc = "Production" }
                            "2" { $svc = "Comptabilite" }
                            "3" { $svc = "Commercial" }
                            "4" { $svc = "Ressources Humaines" }
                            "5" { $svc = "Informatique" }
                            "6" { $svc = "Direction" }
                            # FIXE : idem, default manquant
                            default {
                                Write-Host "Choix invalide." -ForegroundColor Red
                                $svc = $null
                            }
                        }
                        if ($svc) {
                            New-ADOrganizationalUnit -Name $svc -Path "OU=Utilisateurs,OU=$aff,$baseDN" -ErrorAction SilentlyContinue
                            Write-Host "OU '$svc' creee sous 'Utilisateurs > $aff'." -ForegroundColor Green
                        }
                    }
                }

            } while ($choixOU -ne "x")
        }

        "2" {
            do {
                Clear-Host
                Write-Host "=================== Crea user - Batiment ==================="
                Write-Host "1 - Service"
                Write-Host "2 - Usine"
                Write-Host "x - Retour"
                Write-Host "============================================================"
                $choixBat = Read-Host "Dans quel batiment est l'utilisateur"

                switch ($choixBat) {

                    "1" {
                        do {
                            Clear-Host
                            Write-Host "=================== Crea user - Service - Fonction ==================="
                            Write-Host "1 - Production"
                            Write-Host "2 - Comptabilite"
                            Write-Host "3 - Commercial"
                            Write-Host "4 - Ressources Humaines"
                            Write-Host "5 - Informatique"
                            Write-Host "6 - Direction"
                            Write-Host "x - Retour"
                            Write-Host "======================================================================"
                            $choixFonction = Read-Host "Quel est la fonction de l'utilisateur"

                            switch ($choixFonction) {
                                "1" { New-UtilisateurAD -TargetOU "OU=Production,OU=Utilisateurs,OU=Service,$baseDN"          -GroupName "GG_Production" }
                                "2" { New-UtilisateurAD -TargetOU "OU=Comptabilite,OU=Utilisateurs,OU=Service,$baseDN"        -GroupName "GG_Compta" }
                                "3" { New-UtilisateurAD -TargetOU "OU=Commercial,OU=Utilisateurs,OU=Service,$baseDN"          -GroupName "GG_Commercial" }
                                "4" { New-UtilisateurAD -TargetOU "OU=Ressources Humaines,OU=Utilisateurs,OU=Service,$baseDN" -GroupName "GG_RH" }
                                "5" { New-UtilisateurAD -TargetOU "OU=Informatique,OU=Utilisateurs,OU=Service,$baseDN"        -GroupName "GG_Informatique" }
                                "6" { New-UtilisateurAD -TargetOU "OU=Direction,OU=Utilisateurs,OU=Service,$baseDN"           -GroupName "GG_Direction" }
                                "x" { Write-Host "Retour..." }
                                default { Write-Host "Entre une bonne option salopio !" -ForegroundColor Red }
                            }

                        } while ($choixFonction -ne "x")
                    }

                    "2" {
                        do {
                            Clear-Host
                            Write-Host "=================== Crea user - Usine - Fonction ==================="
                            Write-Host "1 - Production"
                            Write-Host "2 - Comptabilite"
                            Write-Host "3 - Commercial"
                            Write-Host "4 - Ressources Humaines"
                            Write-Host "5 - Informatique"
                            Write-Host "6 - Direction"
                            Write-Host "x - Retour"
                            Write-Host "===================================================================="
                            $choixFonction = Read-Host "Quel est la fonction de l'utilisateur"

                            switch ($choixFonction) {
                                "1" { New-UtilisateurAD -TargetOU "OU=Production,OU=Utilisateurs,OU=Usine,$baseDN"          -GroupName "GG_Production" }
                                "2" { New-UtilisateurAD -TargetOU "OU=Comptabilite,OU=Utilisateurs,OU=Usine,$baseDN"        -GroupName "GG_Compta" }
                                "3" { New-UtilisateurAD -TargetOU "OU=Commercial,OU=Utilisateurs,OU=Usine,$baseDN"          -GroupName "GG_Commercial" }
                                "4" { New-UtilisateurAD -TargetOU "OU=Ressources Humaines,OU=Utilisateurs,OU=Usine,$baseDN" -GroupName "GG_RH" }
                                "5" { New-UtilisateurAD -TargetOU "OU=Informatique,OU=Utilisateurs,OU=Usine,$baseDN"        -GroupName "GG_Informatique" }
                                "6" { New-UtilisateurAD -TargetOU "OU=Direction,OU=Utilisateurs,OU=Usine,$baseDN"           -GroupName "GG_Direction" }
                                "x" { Write-Host "Retour..." }
                                default { Write-Host "Entre une bonne option salopio !" -ForegroundColor Red }
                            }

                        } while ($choixFonction -ne "x")
                    }

                    "x" { Write-Host "Retour au menu principal." }
                    default { Write-Host "Entre une bonne option salopio !" -ForegroundColor Red }
                }

            } while ($choixBat -ne "x")
        }
    }

} while ($choix -ne "x")

Write-Host "Au revoir !" -ForegroundColor Yellow
