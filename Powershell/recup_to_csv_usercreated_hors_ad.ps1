########################################################################################################
# Author : Mattéo AUBRY                                                                                #
# Date : 18/02/2025                                                                                    #
# Description : Permet de recup un csv avec la date de crea des user présent sur l'ordi (hors AD )     #
# Version : 1.0                                                                                        #
# Name : lan.ps1                                                                                       #
########################################################################################################

function fun_recup_to_csv_usercreated_hors_ad {
    param (
        [string]$Path
    )
    $client = Read-Host "Entrez le nom du client"
    $csvPath = "./'$client'_recap-user_pour-Louise-la-plus-belle.csv"

    Out-File -FilePath $csvPath -Encoding utf8

    $UserFolders = Get-ChildItem -Path $Path -Directory
    $UserFolders | ForEach-Object {
        $FolderName = $_.Name
        $CreationDate = $_.CreationTime
        [PSCustomObject]@{
            UserFolder = $FolderName
            CreationDate = $CreationDate
        }
    } | Export-Csv -Path $csvPath -NoTypeInformation -Append

    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show("Fichier recap csv sauvegarde dans $csvPath")
}

fun_recup_to_csv_usercreated_hors_ad -Path "C:\Users"