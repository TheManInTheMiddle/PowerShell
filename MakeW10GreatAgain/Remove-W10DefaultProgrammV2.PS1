$SoftToRemoveTable = @("Microsoft.3DBuilder",
"Microsoft.Getstarted",
"Microsoft.MicrosoftOfficeHub",
"Microsoft.MicrosoftSolitaireCollection",
"Microsoft.SkypeApp",
"Microsoft.WindowsMaps",
"Microsoft.BingWeather",
"Microsoft.Office.OneNote",
"Microsoft.XboxApp",
"Microsoft.XboxGameCallableUI",
"Microsoft.XboxIdentityProvider",
"Microsoft.Xbox.TCUI",
"Microsoft.XboxGamingOverlay",
"Microsoft.ZuneMusic",
"Microsoft.Music.Preview",
"Microsoft.BingSports",
"Microsoft.BingNews",
"Microsoft.BingFinance",
"Microsoft.BingTravel",
"Microsoft.BingHealthAndFitness",
"Microsoft.BingFoodAndDrink",
"Microsoft.BingWeather",
"Microsoft.WindowsPhone",
"Microsoft.WindowsSoundRecorder",
"Microsoft.Windows.Photos",
"Microsoft.WindowsCamera",
"Microsoft.WindowsAlarms",
"Microsoft.People",
"Microsoft.Office.OneNote",
"Microsoft.BioEnrollment",
"Microsoft.Wallet",
"Microsoft.WindowsFeedbackHub",
"Microsoft.Messaging",
"Microsoft.WindowsMaps",
"Microsoft.Print3D",
"Microsoft.WindowsStore",
"Fitbit.FitbitCoach",
"Microsoft.ScreenSketch",
"king.com.CandyCrushSaga"
)
foreach ($p in $SoftToRemoveTable){
    Get-AppxPackage -AllUsers -Name $p | Remove-AppxPackage}

#Desactive cortana source : https://gallery.technet.microsoft.com/scriptcenter/How-to-disable-Cortana-on-b44924a4
$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"    
if(!(Test-Path -Path $path)) {New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Windows Search"} 
Set-ItemProperty -Path $path -Name "AllowCortana" -Value 0 
#Restart Explorer to change it immediately    
Stop-Process -name explorer

#Supprime/desactive l'application OneDrive
$PSScriptRoot\Remove-OneDrive.ps1


