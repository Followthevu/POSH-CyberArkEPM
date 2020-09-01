function Get-CyArkEPMComputers() {
<#
.Synopsis 
This method retrieves the computers from a Set.
.Description 
This method retrieves the computers from a Set. 
You may also apply a limit, filter, and offset for your query

Valid operators for ComputerName filter:

- eq
- in
- contains

Valid operators for Platform and Status filter:

- eq
- in

.Example
Get-CyArkEPMComputers -SetID <Set ID> -Filter "contains(ComputerName, '01')"
The following example returns the computer whose name is 'comp01'

.Example
Get-CyArkEPMComputers -SetID <Set ID> -Filter  "ComputerName in('comp01', 'comp02')"
The following example returns computers whose names are either 'comp01' or 'comp02':

.Example
Get-CyArkEPMComputers -SetID <Set ID> -Filter "contains(ComputerName, '01')"
The following example returns computers whose computer name contains '01'. For example, 'comp01', 'desktop01', '101-server':

.Example
Get-CyArkEPMComputers -SetID <Set ID> -Filter "Platform eq 'MacOS' and ComputerName in('comp01', 'comp02')"
The following example returns MacOS computers whose name is either 'comp01' or 'comp02':

.Example
Get-CyArkEPMComputers -SetID <Set ID> -Filter "Status in('Disconnected', 'Support')"
The following example returns computers whose status is either 'Disconnected' or 'Support':

.Example
Get-CyArkEPMComputers -SetID <Set ID> -Filter "Platform eq 'Windows' and Status eq 'Alive'"
The following example returns computers whose platform is 'Windows' and status is 'Alive'.

#>
    Param(
        [parameter(Mandatory=$true)]
        [string]$SetID,
        [int]$Offset,
        [ValidateRange(1,5000)]
        [int]$Limit,
        [string]$Filter,
        [string]$Version
    )

    $ComputersUri = "https://$epmserver/EPM/API/Sets/$SetID/Computers"

    if ($Version) { $ComputersUri = "https://$epmserver/EPM/API/$Version/Sets/$SetID/Computers"}


    if ($Offset -or $Limit -or $Filter) { $ComputersUri =  $ComputersUri + "?" }

    $Query = @()

    #For offset command
    if ($Offset) {
        $Query += ("Offset=" + $Offset)
    } 
    #For limit param
    if ($Limit) {
        $Query += ("Limit=" + $Limit)
    } 
    #For filter param
    if ($Filter) {
        $Query += ('$filter=' + "$Filter")
    }

    $QueryString = ($Query -join "&")


    $ComputersUri = $ComputersUri + $QueryString


    try {

        $Computersrequest = Invoke-WebRequest -Uri $ComputersUri -ContentType "application/json" -Method "GET" -header $EpmHeader

        $Computerscontent = $Computersrequest.content | Convertfrom-Json


        
    } catch {
        # Dig into the exception to get the Response details.
        # Note that value__ is not a typo.
        Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
    }   

    return $Computerscontent.computers

}