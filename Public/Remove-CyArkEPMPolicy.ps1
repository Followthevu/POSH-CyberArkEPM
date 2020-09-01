function Remove-CyArkEPMPolicy() {
    <# Filter does not work yet#>
    Param(
        [string]$SetID,
        [string]$PolicyId,
        [string]$Version

    )

    $RemovePolicyUri = "https://${epmserver}/EPM/API/Sets/${SetID}/Policies/${PolicyId}"

    if ($Version) {

        $RemovePolicyUri = "https://${epmserver}/EPM/API/${Version}/Sets/${SetID}/Policies/${PolicyId}"

    }


    try {

        $RemovePolicyRequest = Invoke-WebRequest -Uri $RemovePolicyUri -ContentType "application/json" -Method "DELETE" -header $EpmHeader

        $RemovePolicyRequest

        if ($RemovePolicyRequest.StatusCode -eq "204" ) {

            Write-Host "`nPOLICY ${PolicyId} has been removed`n"

        }
        
    } catch {
        # Dig into the exception to get the Response details.
        # Note that value__ is not a typo.
        Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
    }   


}