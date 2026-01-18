#Définition des variables
$ovpnFilePath= "C:\Program Files\OpenVPN\config\" 
$ovpnFile=  Get-ChildItem -Path $ovpnFilePath -Filter *.ovpn 

#Vérification que le repertoire ne soit pas vide
if ($ovpnFile.Count -lt 1) {
    Write-Host "Aucun fichier .ovpn trouve, tache non cree"
    exit
}

function Create-ScheduledTask {
    $action = New-ScheduledTaskAction -Execute $scriptPath -Argument $arguments
    $trigger = New-ScheduledTaskTrigger -At $triggerTime -Daily
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

    $task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal

    Register-ScheduledTask -TaskName $taskName -InputObject $task
    Write-Host "Tache planifiée '$taskName' créée avec succès."
}

#Verification si la tache planifiée existe déjà 
$verifTask = Get-ScheduledTask -TaskName "OpenVPN AUTO" -ErrorAction SilentlyContinue
if ($null -ne $verifTask) {
    Write-Host "La tache planifiée existe déjà, recreation de cette derniere..."
    #On arrete et on supprime la tache exitstante
    Stop-ScheduledTask -TaskName "OpenVPN AUTO"
    Unregister-ScheduledTask -TaskName "OpenVPN AUTO" -Confirm:$false
    #On recree la tache

    exit
}







$vpn1  = $ovpnFile[0].FullName
$vpnArgs1 = "--connect `"$vpn1"`"
if $ovpnFile.Count -ge 2 {
    $vpn2  = $ovpnFile[1].FullName
    $vpnArgs2 = "--connect `"$vpn2"`"
}
