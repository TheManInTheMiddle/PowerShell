<#
Script generation de fichier

Ce script génére plusieurs dossiers à la racine de C: et rempli ces dossiers de plusieurs fichiers

Pour alimenter un serveur de fichier rapidement, pour des tests, SOC, etc...
#>

$RacineFolder = "FSGeneratorFolder"
$Folder = "Comptabilite", "Production", "Donnees", "Direction", "Devellopement", "J'ecoute votre casette en boucle"
$InnerFolder = "OLD", "2015","2016","2017","2018","2019","Client", "Secret"
$Extension = "txt","xls","xlsx","doc","docx","pdf","bin","sql","exe","mp3","wav","iso","zip","csv","ppt","plgx", "bit"


#créer un dossier racine
New-Item -ItemType Directory -Path / -Name $RacineFolder

#générer Plusieurs dossier
foreach ($f in $Folder){
    New-Item -ItemType Directory -Path "C:\$RacineFolder" -Name $f
    foreach ($if in $InnerFolder){
        New-item -ItemType Directory -Path "C:\$RacineFolder\$f" -Name $if
        }
}

#Et un petit dossier en boucle hihi
$BoucleLocation = $RacineFolder + "\" + $Folder[5]
Set-Location -Path "C:\$BoucleLocation"
$i = 0
while ($i -ne 18){
    New-Item -ItemType Directory -Path . -Name "En boucle"
    New-Item -ItemType File -Path . -Name "En boucle.inf"
    Set-Location -Path "En boucle"
    $i++
}

#Et plusieurs fichiers dans ces dossier
$NumberFile = Get-Random -Maximum 256

foreach ($f in $Folder){
    $i = 0
    while ($i -ne $NumberFile){
        $RandomExtension = Get-Random -Maximum 17 
        $RandomName = -join ((65..90) + (97..122) | Get-Random -Count 12 | % {[char]$_})
        $Name = $RandomName + "." + $Extension[$RandomExtension]
        New-Item -ItemType File -Path "c:\$RacineFolder\$f" -Name $Name
        $i++
    }
    foreach ($if in $InnerFolder){
        $i = 0
        while ($i -ne $NumberFile){
            $RandomExtension = Get-Random -Maximum 17 
            $RandomName = -join ((65..90) + (97..122) | Get-Random -Count 12 | % {[char]$_})
            $Name = $RandomName + "." + $Extension[$RandomExtension]
            New-Item -ItemType File -Path "c:\$RacineFolder\$f\$if" -Name $Name
            $i++
    }
    
    }
}

Set-Location $PSScriptRoot