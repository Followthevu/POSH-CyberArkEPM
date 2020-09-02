function Update-CyArkEPMPolicy(){
<# 
.Synopsis 
Updates a Windows Advanced Policy in the EPM
.Description 
Updates a Windows Advanced Policy in the EPM

.Example 
Update-CyArkEPMPolicy -SetID <Set ID> -PolicyId <Policy ID> -PolicyDetails <Policy Details Object>
#>
    Param(
        [parameter(Mandatory=$true)]
        [string]$SetId,
        [parameter(Mandatory=$true)]
        [string]$PolicyId,
        [string]$Version,
        [parameter(Mandatory=$true)]
        $PolicyDetails

    )

    $UpdatePolicyUri = "https://$global:EpmServer/EPM/API/Sets/$SetId/Policies/$PolicyId"
    
    if ($Version) {

        $UpdatePolicyUri = "https://$global:EpmServer/EPM/API/$Version/Sets/$SetId/Policies/$PolicyId"

    }

    $Body = $PolicyDetails | Convertto-Json -Depth 5

    try {

        $CreatePolicy = Invoke-WebRequest -Uri $UpdatePolicyUri -ContentType "application/json" -Method "PUT" -Body ($Body) -header $EpmHeader

        $CreatePolicyContent = $CreatePolicy.content | Convertfrom-Json
        $CreatePolicy
        
    } catch {
        # Dig into the exception to get the Response details.
        # Note that value__ is not a typo.
        $Err = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host $Err.Fields
        Write-Host $Err.ErrorCode
        Write-Host $Err.ErrorMessage
        Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription

        break
    }


}