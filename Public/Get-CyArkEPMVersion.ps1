function Get-CyArkEPMVersion() {
<# 
 .Synopsis 
  Returns the EPM Version number for the current server.
 .Description 
  Retrieves EPM Version number for the selected server.
 .Example 
  Get-CyArkEPMVersion
#>
	$Uri = "https://${EpmServer}/EPM/API/Server/Version"

	try {

        $epmversionrequest = Invoke-WebRequest -Uri $Uri -ContentType "application/json" -Method "Get"

        $epmversioncontent = $epmversionrequest.content | Convertfrom-Json
        
	} catch {
	    # Dig into the exception to get the Response details.
	    # Note that value__ is not a typo.
	    Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
	    Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
	}	

	return $epmversioncontent.version

}