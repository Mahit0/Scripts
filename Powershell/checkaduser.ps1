##################################################
# Author : Mattéo AUBRY                          #
# Date : 18/02/2025                              #
# Description : checkaduser                      #
# Version : 1.3                                  #
# Name : checkaduser.ps1                         #
##################################################

Import-Module ActiveDirectory

$htmlPath = "$env:USERPROFILE\Desktop\liste-utilisateurs.html"
$ou = "OU=Utilisateur,OU=_MLG,DC=MLG,DC=lan"

$users = Get-ADUser -Filter * -SearchBase $ou -Properties SamAccountName, LastLogon, Enabled |
    Select-Object SamAccountName,
                  @{Name="LastLogon"; Expression={([datetime]::FromFileTime($_.LastLogon)).ToString("yyyy-MM-dd HH:mm")}},
                  @{Name="Statut"; Expression={if ($_.Enabled) {'Actif'} else {'Desactive'}}}

$html = @"
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Utilisateurs AD - $ou</title>
    <style>
        body { font-family: Arial; background-color: #f4f4f4; padding: 20px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; cursor: pointer; }
        tr:hover { background-color: #f1f1f1; }
        .desactive { background-color: #ffe6e6; }
    </style>
</head>
<body>
    <h2>Liste des utilisateurs de l'OU : $ou</h2>
    <p>Cliquez sur "<strong>Derniere connexion</strong>" pour trier les utilisateurs par date.</p>
    <table id="userTable">
        <thead>
            <tr>
                <th>Nom d'utilisateur</th>
                <th onclick="sortTable()">Derniere connexion</th>
                <th>Statut</th>
            </tr>
        </thead>
        <tbody>
"@

foreach ($user in $users) {
    $rowClass = if ($user.Statut -eq "Desactive") { " class='desactive'" } else { "" }
    $html += "<tr$rowClass><td>$($user.SamAccountName)</td><td>$($user.LastLogon)</td><td>$($user.Statut)</td></tr>`n"
}

$html += @"
        </tbody>
    </table>

    <script>
    let ascending = true;

    function sortTable() {
        const table = document.getElementById("userTable").getElementsByTagName("tbody")[0];
        const rows = Array.from(table.rows);

        rows.sort((a, b) => {
            const aDate = new Date(a.cells[1].innerText);
            const bDate = new Date(b.cells[1].innerText);
            return ascending ? aDate - bDate : bDate - aDate;
        });

        ascending = !ascending;
        rows.forEach(row => table.appendChild(row));
    }
    </script>

</body>
</html>
"@

$html | Out-File -Encoding UTF8 -FilePath $htmlPath

