function Set-CyArkEPMHeader(){

    Param(
        [string]$AuthToken
    )

    $global:EpmHeader = @{ "Authorization" ="Basic " + $AuthToken }

    Write-Host "$(Get-Date) Authorization has been set."

}