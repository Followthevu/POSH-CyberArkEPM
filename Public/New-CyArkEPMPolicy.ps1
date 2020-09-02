function New-CyArkEPMPolicy(){
<# 
.Synopsis 
This method creates a new EPM policy.
.Description 
This method creates a new EPM policy.
.Example 
New-CyArkEPMPolicy -SetID <set id> -PolicyDetails <Object from New-CyarkEPMPolicyDetails>
#>
    Param(
        [parameter(Mandatory=$true)]
        [string]$SetID,
        [string]$Version,
        [parameter(Mandatory=$true)]
        $PolicyDetails
    )

    $uri = "https://$global:EpmServer/EPM/API/Sets/$SetID/Policies"
    
    if ($Version) {

        $uri = "https://$global:EpmServer/EPM/API/$Version/Sets/$SetID/Policies"

    }

    $Body = $PolicyDetails | Convertto-Json -Depth 5

    try {

        $CreatePolicy = Invoke-WebRequest -Uri $uri -ContentType "application/json" -Method "Post" -Body ($Body) -header $EpmHeader

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