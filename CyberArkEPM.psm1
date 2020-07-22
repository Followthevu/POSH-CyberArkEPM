#Retrieve public and private definition files.
    $Public = @( Get-ChildItem -Path .\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path .\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot sourcing the files
    Foreach ( $import in @($Public + $Private))
    {
        Try 
        {
            . $import.fullname
        }
        Catch 
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }

Export-ModuleMember -Function $Public.Basename

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#global variables
$global:EpmHeader = $null
#if using CyberArkAIM for authentication
$global:ApiAccount = $null
$global:CyberArkAIMServer = ""
$global:CyberArkSafeName = ""
$global:CyberArkAppID = ""
$global:CyberArkObjectName = ""

#Server settings
#You can leave it as 1 or put multiple servers
$global:EpmServer = @()

if ($EpmServer.count -ge 2) {

    $global:EpmServer = $global:EpmServer | Get-Random

}