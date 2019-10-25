<#
Sources :
https://freeProfessionelductkeys.com/wp-content/uploads/2019/05/text-to-activate-Windows-Server.txt
https://freeProfessionelductkeys.com/how-to-activate-windows-server-without-Professionelduct-key/
https://docs.microsoft.com/en-us/windows-server/get-started/kmsclientkeys
#>

#$PSDefaultParameterValues['*:Encoding']='utf8'

$OS = (Get-WmiObject -Class Win32_OperatingSystem).caption
$OS = $OS -replace '(^\s+|\s+$)','' -replace '\s+',' ' #pour enlever les espace en début et fin de string. Nik w7 entrerprise

function install-licence($LicenceKey){
    
    slmgr /ipk $LicenceKey
    Write-Host "incription de la clé de licence..."
    sleep 5
    slmgr /skms kms8.msguides.com
    Write-Host "Inscrition du serveur KMS"
    sleep 1
    slmgr /ato
    Write-Host "Application des paramètres"
    sleep 9   
}

Start-Process "https://docs.microsoft.com/en-us/windows-server/get-started/kmsclientkeys"
$LicenceKey = Read-Host "Entrez la licence pour la version $OS "

Write-Host "
Attendez l'execution de slmgr..."
install-licence $LicenceKey
Read-Host "OK ! Lisez le retour de slmgr. Il ne faut aucune erreur"