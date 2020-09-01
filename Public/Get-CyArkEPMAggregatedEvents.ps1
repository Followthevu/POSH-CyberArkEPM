function Get-CyArkEPMAggregatedEvents() {

<# 
 .Synopsis 
  Returns the Policies for a specific Set from the EPM.
 .Description 
  Returns the Policies for a specific Set from the EPM.

  The request can be modified by using:

    Version - API version
       
      Get-CyArkEPMAggregatedEvents -Version <Version Number>
        -Version <Version>
            Valid value: Version number. Format is x.x.x.x (for example, 11.5.0.1)

    Limit - Maximum number of sets to return

      Get-CyArkEPMAggregatedEvents -Limit <Limit>
        -Limit <Limit>
            Valid value: 1-1000

    Offset - Number of sets to skip

      Get-CyArkEPMAggregatedEvents -Offset <Offset>
        -Offset <Offset>
            Valid value: 0 (zero) or higher

    EventType - Specify All or a list of event types separated by commas.

        To get EventTypes: Get-CyArkEPMAggregatedEvents -ListEventTypes

    
    Publisher - Digital signature of the application that triggered the event (if applicable). Wildcards and unsigned are supported.
        
        Valid Values:
        -> "xxx xxx" - filters the exact value between the quotes
        -> xxx xxx - filters anything that contains the string
        -> *xxx xxx* - filters anything that contains the string between the *
        -> xxx* - filters all strings that start with the value before the *
        -> *xxx - filters all strings that end with the value after the *
    
    PolicyName - Name of the policy that triggers the event. Wildcards are supported.
        
        Valid Values:
        -> "xxx xxx" - filters the exact value between the quotes
        -> xxx xxx - filters anything that contains the string
        -> *xxx xxx* - filters anything that contains the string between the *
        -> xxx* - filters all strings that start with the value before the *
        -> *xxx - filters all strings that end with the value after the *

  Please see https://docs.cyberark.com/Product-Doc/OnlineHelp/EPM/Latest/en/Content/WebServices/GetAggregatedEvents.htm for more information
 .Example 
  Get-CyArkEPMAggregatedEvents -Version 11.5.0.1

  Get-CyArkEPMAggregatedEvents -Limit 500

  Get-CyArkEPMAggregatedEvents -Offset 20

  Get-CyArkEPMAggregatedEvents -Offset 2 -Limit 500

  Get-CyArkEPMAggregatedEvents -SetID $sets.id -Category ApplicationEvents -EventType All -ApplicationType all

#>


    Param(
        [parameter(Mandatory=$true)]
        [string]$SetID,
        [parameter(Mandatory=$true)]
        [ValidateSet('ApplicationEvents','PolicyAudit','ThreatDetection')]
        [string]$Category,
        [string]$Version,
        [int]$Offset,
        [ValidateRange(1,1000)]
        [int]$Limit,
        [ValidateSet('All','Attack','SuspiciousActivity','ElevationRequest','Trust','Installation','Launch','ManualRequest','Block','Access','Ransomware','Trust','Installation','Launch','Block','Access','StartElevated','Computer')]
        [string]$EventType,
        [switch]$ListEventTypes,
        [string]$Publisher,
        [string]$DateFrom,
        [string]$DateTo,
        [ValidateSet('All','WithJustification')]
        [string]$Justification,
        [ValidateSet('All','Executable','Script','MSI','MSU','ActiveX','Com','Win8App','DLL','DMG','PKG')]
        [string]$ApplicationType,
        [string]$ApplicationTypeCustom,
        [string]$PolicyName
    )

    if ($ListEventTypes) {

        Get-CyberArkEventTypes
    }

    $AggregatedEventsUri = "https://$epmserver/EPM/API/Sets/$SetID/Events/$Category"

    if ($Version) {
    
        $AggregatedEventsUri = "https://$epmserver/EPM/API/$Version/Sets/$SetID/Events/$Category"

    }

    if ($DateFrom) { $DateFrom = Get-date $DateFrom -Format s }
    
    if ($DateTo) { $DateTo = Get-date $DateTo -Format s }

    $Query = @()

    if ($Offset -or $Limit -or $EventType -or $Publisher -or $DateFrom -or $DateTo -or $Justification -or $ApplicationType -or $ApplicationTypeCustom -or $PolicyName) {
        
         $AggregatedEventsUri =  $AggregatedEventsUri + "?"
        
    }

    if ($ApplicationType -and $ApplicationTypeCustom) {

        Write-host "You cannot have ApplicationType and ApplicationTypeCustom"
        break

    } elseif ($ApplicationType) {

        $Query += ("ApplicationType=" + $ApplicationType)

    } elseif ($ApplicationTypeCustom) {

        $Query += ("ApplicationType=" + $ApplicationTypeCustom)

    }

    if ($Offset) {
        $Query += ("Offset=" + $Offset)
        #Write-Host "Uri will be: " + $Uri
    } 
    if ($Limit) {
        $Query += ("Limit=" + $Limit)
        #Write-Host "Uri will be: " + $Uri
    } 
    if ($EventType) {
        $Query += ("EventType=" + $EventType)
        #Write-Host "Uri will be: " + $Uri
    } 
    if ($Publisher) {
        $Query += ("Publisher=" + $Publisher)
        #Write-Host "Uri will be: " + $Uri
    } 
    if ($DateFrom) {
        $Query += ("DateFrom=" + $DateFrom)
        #Write-Host "Uri will be: " + $Uri
    } 
    if ($DateTo) {
        $Query += ("DateTo=" + $DateTo)
        #Write-Host "Uri will be: " + $Uri
    } 
    if ($Justification) {
        $Query += ("Justification=" + $Justification)
        #Write-Host "Uri will be: " + $Uri
    } 
    if ($PolicyName) {
        $Query += ("PolicyName=" + $PolicyName)
        #Write-Host "Uri will be: " + $Uri
    } 


    $QueryString = ($Query -join "&")

    $AggregatedEventsUri = $AggregatedEventsUri + $QueryString


    try {

        $AggregatedEventsrequest = Invoke-WebRequest -Uri $AggregatedEventsUri -ContentType "application/json" -Method "Get" -header $EpmHeader

        $AggregatedEventscontent =  $AggregatedEventsrequest.content | Convertfrom-Json
        
    } catch {
        # Dig into the exception to get the Response details.
        # Note that value__ is not a typo.
        Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
    }   

    return $AggregatedEventscontent.Events

}