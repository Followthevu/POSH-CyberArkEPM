function Get-CyArkEPMComputerGroups() {
<# 
.Synopsis 
This method retrieves the Computer Groups from a Set.

.Description 
This method retrieves the Computer Groups from a Set. Allows you to also use a filter

Valid values for Filter:

    'Name' - allowed operators
    'Contains' - part of the Computer Group name

.Example 
Get-CyArkEPMComputerGroups -SetID [Set ID Value] -Filter "contains(Name,'MyGroup')"

#>
    Param(
        [parameter(Mandatory=$true)]
        [string]$SetID,
        [string]$Version,
        [string]$Filter
    )

    $ComputerGroupsUri = "https://$epmserver/EPM/API/Sets/$SetID/ComputerGroups"

    if ($Version) {

        $ComputerGroupsUri = "https://$epmserver/EPM/API/$Version/Sets/$SetID/ComputerGroups"

    }

    $Query = @()

    if ($Filter) {

        $Query += ('$filter=' + "$Filter")

        $ComputerGroupsUri = $ComputerGroupsUri + "?" + $Query

    }

    try {

        $ComputerGroupsrequest = Invoke-WebRequest -Uri $ComputerGroupsUri -ContentType "application/json" -Method "GET" -header $EpmHeader

        $ComputerGroupscontent =  $ComputerGroupsrequest.content | Convertfrom-Json
        
    } catch {
        # Dig into the exception to get the Response details.
        # Note that value__ is not a typo.
        Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
    }   

    return $ComputerGroupscontent

}