    # Vérifie si le module ExchangeOnlineManagement est installé
    if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
        Write-Output "Le module ExchangeOnlineManagement n'est pas installé. Installation en cours..."
        # Installe le module sans confirmation
        Install-Module ExchangeOnlineManagement -Force -AllowClobber -Scope CurrentUser
    } 
    else {
        Write-Output "Le module ExchangeOnlineManagement est déjà installé."
    }

    # Importation du module
    Import-Module ExchangeOnlineManagement
    Write-Output "Le module ExchangeOnlineManagement est prêt à être utilisé."
    Write-Host "Bonjour $env:username, vous êtes actuellement connecté à la machine $env:COMPUTERNAME" -ForegroundColor green
    #Se connecter au tenant via une fenêtre de connexion
    Connect-ExchangeOnline
    #Stocker les boîtes mails
    $Mailboxes = Get-Mailbox -RecipientTypeDetails UserMailbox, SharedMailbox,Roommailbox, equipmentMailbox -ResultSize Unlimited
    Function Get-CalendarFolder {
        [cmdletbinding()]
        param(
            [ValidateNotNullOrEmpty()]
            [Parameter(
                Mandatory=$true,
                #Permets d'utiliser un pipeline avec la propriété
                ValueFromPipelineByPropertyName=$true
            )]
            [Alias("PrimarySmtpAddress")]
            [string[]]$MailAddress
        )
        #Commencer par créer la liste d'objet powershell dans laquelle stocker les résultats (Sous forme de collection)
        Begin {
            $Collection = New-Object System.Collections.Generic.List[PsObject]
        #Vider la collection pour bien partir de zero puis les rajouter au fur et à mesure
            $Collection.Clear()
        }
        Process {
            ### Pour chaque adresse mail de la liste d'adresse
            Foreach ($Address in $MailAddress) {
            # On sélectionne le dossier calendrier
            ### Construire le chemin du calendrier en français
                $CalendarFolder = "$($Address):\Calendrier"
                Try {
                    #Récupérer les permissions du dossier en français, en cas d'erreur (ex : nom du calendrier qui n'est pas en français), passer a l'étape Catch. $Null = permet de masquer le résultat de la commande.
                    $Null = Get-MailboxFolderPermission -Identity $CalendarFolder -ErrorAction Stop
                } Catch {
                    #On sélectionne le dossier calendar en Anglais
                    ### Construire le chemin du calendrier en anglais
                    $CalendarFolder = "$($Address):\Calendar"
                    Try {
                        ###Récupérer les permissions du dossier en Anglais, en cas d'erreur (Ici, le calendrier n'existe pas, ou est dans une autre langue que anglais / français) $Null = permet de masquer le résultat de la commande.
                        $Null = Get-MailboxFolderPermission -Identity $CalendarFolder -ErrorAction Stop
                    } Catch {
                        #Si aucun des Dossiers ni en anglais ni en français n'ont de permissions, il faut afficher un message d'erreur en particulier et continuer
                        ### Si le calendrier n'existe ni en français, ni en anglais, afficher une erreur, 
                        Write-Error "Erreur : le nom du calendrier de $Address n'est ni en français ni en anglais"
                        ### ne pas poursuivre le traitement de l'adresse actuelle, et passer a l'adresse suivante dans la liste.
                        Continue
                    }
                }
            #Création d'une variable Result pour stocker les résultats sous la forme d'objet avec deux propriétés dans laquelle on renvoie les données trouvées plus tôt
                ### Création de l'objet $Résult pour stocker les informations trouvées. 
                $Result = New-Object PSObject
                ### Ajouter la propriété MailAddress avec en valeur l'adresse email de l'utilisateur
                $Result | Add-Member -MemberType NoteProperty -Name "MailAddress" -Value $Address
                ### Ajouter la propriété Calendar, avec en valeur le chemin complet du calendrier (qu'il soit en anglais ou en français)
                $Result | Add-Member -MemberType NoteProperty -Name "Calendar" -Value $CalendarFolder

                ### Ajout de l'objet result dans la variable collection (A chaque boucle Process ou Foreach (selon l'invocation via Get-Mailbox Get-CalendarFolder | ou Get-CalendarFolder -MAilAddress)
                $Collection.Add($Result)
            }
        }
        End {
            #Si la collection, après avoir fait le tour des adresses, n'a pas d'éléments, il faut renvoyer l'erreur suivante
            ### Si la collection ne contient aucun élément après le traitement, déclencher une erreur
            If ($Collection.Count -eq 0) {
                Throw "Erreur Get-CalendarFolder : Aucun résultat valide. le nom des calendriers n'est pas en anglais ou en français, ou n'existe pas."
            }
            #Montre le contenu de collection
            ### Retourner la collection d'objets Result à la commande qui a appelé la fonction
            Return $Collection
        }
    }

    Function Func_InfoCalendar {
        Write-Host "Vous avec choisi de consulter les permissions."
 #       $UserToConsult=$Mailboxes | Out-GridView -Title "Sélectionnez une boîte mail à consulter" -PassThru
        $SearchBDD=$Mailboxes | Out-GridView -Title "Sélectionnez une boîte mail à consulter" -PassThru
            $Calendar = ($SearchBDD | Get-CalendarFolder).Calendar
            $InfoPermCal=Get-MailboxFolderPermission -Identity $Calendar
            $InfoPermCal | Out-GridView -Title "Liste des permissions"
    }
        function Func_MainMenu {
    do {
        clear-host
        Write-Host "Bienvenue sur ce script de gestion des permissions calendriers" -ForegroundColor Green
        Write-Host "1) Consultation des permissions d'un calendrier donné"
        Write-Host "2) Bah quitter sale fou"
        $choix = Read-Host "Faites votre choix"
    switch ($choix) {
        1 {Func_InfoCalendar}
        2 { exit }
    }
    }while ($true)
    }
    Func_MainMenu