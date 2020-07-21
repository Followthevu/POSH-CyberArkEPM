function Get-CyArkEPMPolicies() {
<# 
 .Synopsis 
  Returns the Policies for a specific Set from the EPM.
 .Description 
  Returns the Policies for a specific Set from the EPM.

  The request can be modified by using:

    Version - API version
       
      Get-CyArkEPMSetsList -Version <Version Number>
        -Version <Version>
            Valid value: Version number. Format is x.x.x.x (for example, 11.5.0.1)

    Limit - Maximum number of sets to return

      Get-CyArkEPMSetsList -Limit <Limit>
        -Limit <Limit>
            Valid value: 1-1000

    Offset - Number of sets to skip

      Get-CyArkEPMSetsList -Offset <Offset>
        -Offset <Offset>
            Valid value: 0 (zero) or higher

 .Example 
  Get-CyArkEPMPolicies -Version 11.5.0.1

  Get-CyArkEPMPolicies -Limit 500

  Get-CyArkEPMPolicies -Offset 20

  Get-CyArkEPMPolicies -Offset 2 -Limit 500
#>
	Param(
        [parameter(Mandatory=$true)]
		[string]$SetID,
        [string]$Version,
        [int]$Offset,
        [ValidateRange(1,1000)]
        [int]$Limit
        #[ValidateSet('Windows Application Advanced Policy','JIT Access and Elevation Policy','Either')]
        #[string]$PolicyType
    )

    $SetPoliciesUri = "https://${EpmServer}/EPM/API/Sets/${SetID}/Policies"

    if ($Version) {

        $SetPoliciesUri = "https://${EpmServer}/EPM/API/${Version}/Sets/${SetID}/Policies"

    }

    if ($Offset -or $Limit) {
        
        $SetPoliciesUri = $SetPoliciesUri + "?"
        
    }

    $Query = @()

    if ($Offset) {
        $Query += ("Offset=" + $Offset)
        #Write-Host "Uri will be: " + $Uri
    } 
    if ($Limit) {
        $Query += ("Limit=" + $Limit)
        #Write-Host "Uri will be: " + $Uri
    }

    $QueryString = ($Query -join "&")

    $SetPoliciesUri = $SetPoliciesUri  + $QueryString
	

	try {

        $setpolicyrequest = Invoke-WebRequest -Uri $SetPoliciesUri -ContentType "application/json" -Method "Get" -header $EpmHeader

        $setpolicycontent =  $setpolicyrequest.content | Convertfrom-Json
        
	} catch {
	    # Dig into the exception to get the Response details.
	    # Note that value__ is not a typo.
	    Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
	    Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
	}	

	return $setpolicycontent.Policies

}