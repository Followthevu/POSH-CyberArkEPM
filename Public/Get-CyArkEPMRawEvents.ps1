function Get-CyArkEPMRawEvents() {
<# 
.Synopsis 
This method enables the user to retrieve raw events file data from EPM according to a predefined filter.
.Description 
This method enables the user to retrieve raw events file data from EPM according to a predefined filter.

PolicyName wild cards:

    "xxx xxx" - filters the exact value between the quotes
    xxx xxx - filters anything that contains the string
    *xxx xxx* - filters anything that contains the string between the *
    xxx* - filters all strings that start with the value before the *
    *xxx - filters all strings that end with the value after the *

.Example 
Get-CyArkEPMRawEvents -SetID <SetID> -Category <Category>
#>
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
        [string]$DateFrom,
        [string]$DateTo,
        [ValidateSet('All','WithJustification')]
        [string]$Justification,
        [string]$PolicyName
    )

    if ($ListEventTypes) {

        Get-CyberArkEventTypes
    }

    $RawEventsUri = "https://$epmserver/EPM/API/Sets/$SetID/Events/$Category/$FileQualifier"

    if ($Version) {
    
        $RawEventsUri = "https://$epmserver/EPM/API/$Version/Sets/$SetID/Events/$Category/$FileQualifier"

    }

    $Query = @()

    if ($Offset -or $Limit -or $EventType -or $Publisher -or $DateFrom -or $DateTo -or $Justification -or $PolicyName) {
        
         $RawEventsUri =  $RawEventsUri + "?"
        
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
    if ($DateFrom) {
        $DateFrom = Get-date $DateFrom -Format s
        $Query += ("DateFrom=" + $DateFrom)
    } 
    if ($DateTo) {
        $DateTo = Get-date $DateTo -Format s
        $Query += ("DateTo=" + $DateTo)
    } 
    if ($Justification) {
        $Query += ("Justification=" + $Justification)
        #Write-Host "Uri will be: " + $Uri
    } 
    if ($PolicyName) {
        $Query += ("PolicyName=" + $PolicyName)
        #Write-Host "Uri will be: " + $Uri
    } 



    
    if ($DeactivateDate) { 
        
        $DeactivateDate = Get-date $DeactivateDate

        $DDate = [pscustomobject]@{

            Year        =        $DeactivateDate.Year
            Month       =        $DeactivateDate.Month
            Day         =        $DeactivateDate.Day
            Hours       =        $DeactivateDate.Hour
            Minutes     =        $DeactivateDate.Minute
            Seconds     =        $DeactivateDate.Second

        }

        $DDate| Get-Member | ? { $_.membertype -eq "NoteProperty" }  | select -expand Name | ForEach-Object { if ($ddate.$_ -eq $null) { $ddate.$_ = 0 } }

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