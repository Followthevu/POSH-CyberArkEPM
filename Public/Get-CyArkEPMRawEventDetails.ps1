function Get-CyArkEPMRawEventDetails() {
<# 
.Synopsis 
This method enables the user to retrieve raw events file data from EPM according to a predefined filter.
.Description 
This method enables the user to retrieve raw events file data from EPM according to a predefined filter.
.Example 
Get-CyArkEPMRawEventDetails -SetID <SetID> -Category <Category> -EventID <EventID>
#>
    Param(
        [parameter(Mandatory=$true)]
        [string]$SetID,
        [parameter(Mandatory=$true)]
        [ValidateSet("ApplicationEvents","PolicyAudit","ThreatDetection")]
        [string]$Category,
        [parameter(Mandatory=$true)]
        [string]$EventID,
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
        [string]$PolicyName,
        [string]$Hash,
        [string]$FilePath,
        [string]$Company,
        [string]$FileDescription,
        [string]$ProductName,
        [string]$ProductVersion,
        [ValidateSet('Unknown','OldApplication','Internet','Updater','NetworkShare','RemovableDrive','CDRom','Windows','LocalDisk','EPM','LocalShare','Email','DeveloperApp')]
        [string]$SourceType,
        [string]$SourceName,
        [ValidateSet('Unknown','OldApplication','Internet','Updater','NetworkShare','RemovableDrive','CDRom','Windows','LocalDisk','EPM','LocalShare','Email','DeveloperApp')]
        [string]$PreHistorySourceType,
        [string]$PreHistorySourceName,
        [int]$FileSize,
        [string]$Package,
        [string]$FileVersion,
        [string]$ModificationTime,
        [string]$User,
        [Bool]$UserIsAdmin,
        [string]$TimeFirst,
        [string]$TimeLast,
        [int]$AgentEventCount,
        [string]$AccessAction,
        [ValidateSet('Registry','File','ProcessMemory','NetworkShare','Internet','Intranet')]
        [string]$AccessTargetType,
        [string]$AccessTargetName,
        [string]$PolicyCategory,
        [string]$ThreatDetectionAction,
        [string]$ProcessCommandLine,
        [string]$ProcessCertificateIssuer,
        [string]$SourceProcessCommandLine,
        [string]$SourceProcessUsername,
        [string]$SourceProcessHash,
        [string]$SourceProcessPublisher,
        [string]$SourceProcessCertificateIssuer,
        [string]$ExposedUsers,
        [string]$Computer,
        [string]$FileQualifier,
        [string]$FileName

    )

    if ($ListEventTypes) {

        Get-CyberArkEventTypes
    }

    $RawEventDetailUri = "https://$epmserver/EPM/API/Sets/$SetID/Events/$Category/Raw/$EventID"

    if ($Version) {
    
        $RawEventDetailUri = "https://$epmserver/EPM/API/$Version/Sets/$SetID/Events/$Category/Raw/$EventID"

    }

    $Query = @()

    if ($Offset -or $Limit -or $EventType -or $Publisher -or $DateFrom -or $DateTo -or $Justification -or $ApplicationType -or $ApplicationTypeCustom -or $PolicyName -or $Hash -or $FilePath -or $Company -or $FileDescription -or $ProductName -or $ProductVersion -or $SourceType -or $SourceName -or $PreHistorySourceType -or $PreHistorySourceName -or $FileSize -or $Package -or $FileVersion -or $ModificationTime -or $User -or $UserIsAdmin -or $TimeFirst -or $TimeLast -or $AgentEventCount -or $AccessAction -or $AccessTargetType -or $AccessTargetName -or $PolicyCategory -or $ThreatDetectionAction -or $ProcessCommandLine -or $ProcessCertificateIssuer -or $SourceProcessCommandLine -or $SourceProcessUsername -or $SourceProcessHash -or $SourceProcessPublisher -or $SourceProcessCertificateIssuer -or $ExposedUsers -or $Computer -or $FileQualifier -or $FileName) { $RawEventDetailUri =  $RawEventDetailUri + "?" }

    #each if allows the requested parameter to be added to the URI

    if ($Offset) { $Query += ("Offset=" + $Offset) } 

    if ($Limit) { $Query += ("Limit=" + $Limit) } 

    if ($EventType) { $Query += ("EventType=" + $EventType) } 

    if ($Publisher) { $Query += ("Publisher=" + $Publisher) } 

    if ($DateFrom) {
        $DateFrom = Get-date $DateFrom -Format s
        $Query += ("DateFrom=" + $DateFrom)
    } 
    if ($DateTo) {
        $DateTo = Get-date $DateTo -Format s
        $Query += ("DateTo=" + $DateTo)
    } 

    if ($Justification) { $Query += ("Justification=" + $Justification) } 

    if ($PolicyName) { $Query += ("PolicyName=" + $PolicyName) }

    if ($Hash) { $Query += ("Hash=" + $Hash) }

    if ($FilePath) { $Query += ("FilePath=" + $FilePath) }

    if ($Company) { $Query += ("Company=" + $Company) }

    if ($FileDescription) { $Query += ("FileDescription=" + $FileDescription) }

    if ($ProductName) { $Query += ("ProductName=" + $ProductName) }

    if ($ProductVersion) { $Query += ("ProductVersion=" + $ProductVersion) }

    if ($SourceType) { $Query += ("SourceType=" + $SourceType) }

    if ($SourceName) { $Query += ("SourceName=" + $SourceName) }

    if ($PreHistorySourceType) { $Query += ("PreHistorySourceType=" + $PreHistorySourceType) }

    if ($PreHistorySourceName) { $Query += ("PreHistorySourceName=" + $PreHistorySourceName) }

    if ($FileSize) { $Query += ("FileSize=" + $FileSize) }

    if ($Package) { $Query += ("Package=" + $Package) }

    if ($FileVersion) { $Query += ("FileVersion=" + $FileVersion) }

    if ($ModificationTime) { $Query += ("ModificationTime=" + $ModificationTime) }

    if ($User) { $Query += ("User=" + $User) }

    if ($UserIsAdmin) { $Query += ("UserIsAdmin=" + $UserIsAdmin) }

    if ($TimeFirst) { $Query += ("TimeFirst=" + $TimeFirst) }

    if ($TimeLast) { $Query += ("TimeLast=" + $TimeLast) }

    if ($AgentEventCount) { $Query += ("AgentEventCount=" + $AgentEventCount) }

    if ($AccessAction) { $Query += ("AccessAction=" + $AccessAction) }

    if ($AccessTargetType) { $Query += ("AccessTargetType=" + $AccessTargetType) }

    if ($AccessTargetName) { $Query += ("AccessTargetName=" + $AccessTargetName) }

    if ($PolicyCategory) { $Query += ("PolicyCategory=" + $PolicyCategory) }

    if ($ThreatDetectionAction) { $Query += ("ThreatDetectionAction=" + $ThreatDetectionAction) }

    if ($ProcessCommandLine) { $Query += ("ProcessCommandLine=" + $ProcessCommandLine) }

    if ($ProcessCertificateIssuer) { $Query += ("ProcessCertificateIssuer=" + $ProcessCertificateIssuer) }

    if ($SourceProcessCommandLine) { $Query += ("SourceProcessCommandLine=" + $SourceProcessCommandLine) }

    if ($SourceProcessUsername) { $Query += ("SourceProcessUsername=" + $SourceProcessUsername) }

    if ($SourceProcessHash) { $Query += ("SourceProcessHash=" + $SourceProcessHash) }

    if ($SourceProcessPublisher) { $Query += ("SourceProcessPublisher=" + $SourceProcessPublisher) }

    if ($SourceProcessCertificateIssuer) { $Query += ("SourceProcessCertificateIssuer=" + $SourceProcessCertificateIssuer) }

    if ($ExposedUsers) { $Query += ("ExposedUsers=" + $ExposedUsers) }

    if ($Computer) { $Query += ("Computer=" + $Computer) }

    if ($FileQualifier) { $Query += ("FileQualifier=" + $FileQualifier) }

    if ($FileName) { $Query += ("FileName=" + $FileName) }

    #joins all parameters
    $QueryString = ($Query -join "&")

    $RawEventDetailUri = $RawEventDetailUri + $QueryString

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