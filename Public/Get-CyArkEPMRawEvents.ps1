function Get-CyArkEPMRawEvents() {
    
    Param(
        [parameter(Mandatory=$true)]
        [string]$SetID,
        [parameter(Mandatory=$true)]
        [ValidateSet("ApplicationEvents","PolicyAudit","ThreatDetection")]
        [string]$Category,
        [parameter(Mandatory=$true)]
        [string]$FileQualifier,
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

    $RawEventsUri = "https://${EpmServer}/EPM/API/Sets/${SetID}/Events/${Category}/${FileQualifier}"

    if ($Version) {
    
        $RawEventsUri = "https://${EpmServer}/EPM/API/${Version}/Sets/${SetID}/Events/${Category}/${FileQualifier}"

    }

    $Query = @()

    if ($Offset -or $Limit -or $EventType -or $Publisher -or $DateFrom -or $DateTo -or $Justification -or $ApplicationType -or $ApplicationTypeCustom -or $PolicyName) {
        
         $RawEventsUri =  $RawEventsUri + "?"
        
    }

    if ($ApplicationType -and $ApplicationTypeCustom) {

        Write-host "You cannot use ApplicationType and ApplicationTypeCustom"
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

    $RawEventsUri = $RawEventsUri + $QueryString



    try {

        $RawEventsrequest = Invoke-WebRequest -Uri $RawEventsUri -ContentType "application/json" -Method "Get" -header $EpmHeader

        $RawEventscontent =  $RawEventsrequest.content | Convertfrom-Json
        
    } catch {
        # Dig into the exception to get the Response details.
        # Note that value__ is not a typo.
        Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
    }   

    return $RawEventscontent.Events

}