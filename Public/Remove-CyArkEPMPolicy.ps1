function Remove-CyArkEPMPolicy() {
<# 
.Synopsis 
Removes a Windows Advanced Policy in the EPM
.Description 
Removes a Windows Advanced Policy in the EPM

.Example 
Remove-CyArkEPMPolicy -SetID <Set ID> -PolicyId <Policy ID>
#>
    Param(
        [parameter(Mandatory=$true)]
        [string]$SetID,
        [parameter(Mandatory=$true)]
        [string]$PolicyId,
        [string]$Version

    )

    $RemovePolicyUri = "https://$global:EpmServer/EPM/API/Sets/$SetID/Policies/$PolicyId"

    if ($Version) {

        $RemovePolicyUri = "https://$global:EpmServer/EPM/API/$Version/Sets/$SetID/Policies/$PolicyId"

    }

    try {

        $RemovePolicyRequest = Invoke-WebRequest -Uri $RemovePolicyUri -ContentType "application/json" -Method "DELETE" -header $EpmHeader

        $RemovePolicyRequest

        if ($RemovePolicyRequest.StatusCode -eq "204" ) {

            Write-Host "`nPOLICY $PolicyId has been removed`n"

        }
        
    } catch {
        # Dig into the exception to get the Response details.
        # Note that value__ is not a typo.
        Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
    }   


}