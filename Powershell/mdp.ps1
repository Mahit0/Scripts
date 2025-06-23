# Fonction pour generer un mot de passe aleatoire
function Generate-Password {
    param (
        [int]$length = 12
    )
    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!$'
    $password = -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
    return $password
}

# Demander combien de mots de passe different l'utilisateur veut
$numberOfPasswords = Read-Host "Combien de mots de passe differents voulez-vous generer?"

# Generer et afficher les mots de passe
for ($i = 1; $i -le $numberOfPasswords; $i++) {
    $password = Generate-Password
    Write-Output "Mot de passe $i : $password"
}
