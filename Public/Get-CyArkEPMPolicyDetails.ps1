function Get-CyArkEPMPolicyDetails() {
<# 
 .Synopsis 
  Returns the supported fields of a Policy.
 .Description 
  Returns the supported fields of a Policy.
 .Example 
  Get-CyArkEPMPolicyDetails <SetID> <Policy ID>
#>
	Param(
        [parameter(Mandatory=$true)]
		[string]$SetID,
        [parameter(Mandatory=$true)]
		[string]$PolicyID
	)

	$PolicyDetailUri = "https://${EpmServer}/EPM/API/Sets/${SetID}/Policies/${PolicyID}"

	try {

        $policydetailrequest = Invoke-WebRequest -Uri $PolicyDetailUri -ContentType "application/json" -Method "Get" -header $EpmHeader

        $policydetailcontent =  $policydetailrequest.content | Convertfrom-Json
        
	} catch {
	    # Dig into the exception to get the Response details.
	    # Note that value__ is not a typo.
	    Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
	    Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
	}	

	return $policydetailcontent

}