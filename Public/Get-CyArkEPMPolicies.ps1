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
Get-CyArkEPMPolicies -SetID <Set ID> -Version 11.5.0.1
.Example 
Get-CyArkEPMPolicies -SetID <Set ID> -Limit 500
.Example 
Get-CyArkEPMPolicies -SetID <Set ID> -Offset 20
.Example 
Get-CyArkEPMPolicies -SetID <Set ID> -Offset 2 -Limit 500
.Example 
Get-CyArkEPMPolicies -SetID <Set ID> -PolicyType "Windows Application Advanced Policy"
#>
	Param(
        [parameter(Mandatory=$true)]
		[string]$SetID,
        [string]$Version,
        [int]$Offset,
        [ValidateRange(1,1000)]
        [int]$Limit,
        [ValidateSet('Windows Application Advanced Policy','JIT Access and Elevation Policy','Either')]
        [string]$PolicyType
    )

    $SetPoliciesUri = "https://$epmserver/EPM/API/Sets/$SetID/Policies"

    if ($Version) { $SetPoliciesUri = "https://$epmserver/EPM/API/$Version/Sets/$SetID/Policies" }

    if ($Offset -or $Limit) {
        
        $SetPoliciesUri = $SetPoliciesUri + "?"
        
    }

    $Query = @()

    if ($Offset) {
        $Query += ("Offset=" + $Offset)
    } 
    if ($Limit) {
        $Query += ("Limit=" + $Limit)
    }
    if($PolicyType) {

        switch ($PolicyType)
        {
            'Windows Application Advanced Policy' {
                $PolicyType = 'AdvancedWinApp'
                $Query += ('$filter=PolicyType eq' + $PolicyType )
                break
            }
            'JIT Access and Elevation Policy' {
                $PolicyType = 'AdHocElevate'
                $Query += ('$filter=PolicyType eq' + $PolicyType )
                break
            }
            'Either' {
                $PolicyType = "('AdvancedWinApp','AdHocElevate')"
                $Query += ('$filter=PolicyType in' + $PolicyType)
                break
            }
            default { break }
        }

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