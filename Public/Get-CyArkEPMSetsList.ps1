function Get-CyArkEPMSetsList() {
<# 
 .Synopsis 
  Retrieve the list of Sets, sets are returned as objects.
 .Description 
  Retrieve the list of Sets from the EPM Server. The sets are returned as objects. 

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
  
  Get-CyArkEPMSetsList -Version 11.5.0.1

  Get-CyArkEPMSetsList -Limit 500

  Get-CyArkEPMSetsList -Offset 20

  Get-CyArkEPMSetsList -Offset 2 -Limit 500

#>
    Param(
        [string]$Version,
        [int]$Offset,
        [ValidateRange(1,1000)]
        [int]$Limit
    )

    $Uri = "https://${EpmServer}/EPM/API/Sets"

    if ($Version) {

        $Uri = "https://${EpmServer}/EPM/API/${Version}/Sets"

    }

    if ($Offset -or $Limit) {
        
        $Uri = $Uri + "?"
        
    }

    if ($Offset -and $Limit) {
        $Uri = $Uri + "Offset=" + $Offset + "&" + "Limit=" + $Limit
        #Write-Host "Uri will be: " + $Uri
    } elseif ($Offset) {
        $Uri = $Uri + "Offset=" + $Offset
        #Write-Host "Uri will be: " + $Uri
    } elseif ($Limit) {
        $Uri = $Uri + "Limit=" + $Limit
        #Write-Host "Uri will be: " + $Uri
    }
	

	try {

        $epmsetsrequest = Invoke-WebRequest -Uri $uri -ContentType "application/json" -Method "Get" -header $EpmHeader 

        $epmsetscontent = $epmsetsrequest.content | Convertfrom-Json
        
	} catch {
	    # Dig into the exception to get the Response details.
	    # Note that value__ is not a typo.
	    Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
	    Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
	}	

	return $epmsetscontent.sets

}