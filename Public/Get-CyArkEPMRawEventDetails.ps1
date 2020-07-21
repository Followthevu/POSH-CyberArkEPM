function Get-CyArkEPMRawEventDetails() {
    
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
        [ValidateSet('All','Executable','Script','MSI','MSU','ActiveX','Com','Win8App','DLL','DMG','PKG')]
        [string]$ApplicationType,
        [string]$ApplicationTypeCustom,
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

    $RawEventDetailUri = "https://${EpmServer}/EPM/API/Sets/${SetID}/Events/${Category}/Raw/${EventID}"

    if ($Version) {
    
        $RawEventDetailUri = "https://${EpmServer}/EPM/API/${Version}/Sets/${SetID}/Events/${Category}/Raw/${EventID}"

    }

    $Query = @()

    if ($Offset -or $Limit -or $EventType -or $Publisher -or $DateFrom -or $DateTo -or $Justification -or $ApplicationType -or $ApplicationTypeCustom -or $PolicyName -or $Hash -or $FilePath -or $Company -or $FileDescription -or $ProductName -or $ProductVersion -or $SourceType -or $SourceName -or $PreHistorySourceType -or $PreHistorySourceName -or $FileSize -or $Package -or $FileVersion -or $ModificationTime -or $User -or $UserIsAdmin -or $TimeFirst -or $TimeLast -or $AgentEventCount -or $AccessAction -or $AccessTargetType -or $AccessTargetName -or $PolicyCategory -or $ThreatDetectionAction -or $ProcessCommandLine -or $ProcessCertificateIssuer -or $SourceProcessCommandLine -or $SourceProcessUsername -or $SourceProcessHash -or $SourceProcessPublisher -or $SourceProcessCertificateIssuer -or $ExposedUsers -or $Computer -or $FileQualifier -or $FileName) {
        
         $RawEventDetailUri =  $RawEventDetailUri + "?"
        
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
    if ($Hash) { 
        $Query += ("Hash=" + $Hash)
    }
    if ($FilePath) { 
        $Query += ("FilePath=" + $FilePath)
    }
    if ($Company) { 
        $Query += ("Company=" + $Company)
    }
    if ($FileDescription) { 
        $Query += ("FileDescription=" + $FileDescription)
    }
    if ($ProductName) { 
        $Query += ("ProductName=" + $ProductName)
    }
    if ($ProductVersion) { 
        $Query += ("ProductVersion=" + $ProductVersion)
    }
    if ($SourceType) { 
        $Query += ("SourceType=" + $SourceType)
    }
    if ($SourceName) { 
        $Query += ("SourceName=" + $SourceName)
    }
    if ($PreHistorySourceType) { 
        $Query += ("PreHistorySourceType=" + $PreHistorySourceType)
    }
    if ($PreHistorySourceName) { 
        $Query += ("PreHistorySourceName=" + $PreHistorySourceName)
    }
    if ($FileSize) { 
        $Query += ("FileSize=" + $FileSize)
    }
    if ($Package) { 
        $Query += ("Package=" + $Package)
    }
    if ($FileVersion) { 
        $Query += ("FileVersion=" + $FileVersion)
    }
    if ($ModificationTime) { 
        $Query += ("ModificationTime=" + $ModificationTime)
    }
    if ($User) { 
        $Query += ("User=" + $User)
    }
    if ($UserIsAdmin) { 
        $Query += ("UserIsAdmin=" + $UserIsAdmin)
    }
    if ($TimeFirst) { 
        $Query += ("TimeFirst=" + $TimeFirst)
    }
    if ($TimeLast) { 
        $Query += ("TimeLast=" + $TimeLast)
    }
    if ($AgentEventCount) { 
        $Query += ("AgentEventCount=" + $AgentEventCount)
    }
    if ($AccessAction) { 
        $Query += ("AccessAction=" + $AccessAction)
    }
    if ($AccessTargetType) { 
        $Query += ("AccessTargetType=" + $AccessTargetType)
    }
    if ($AccessTargetName) { 
        $Query += ("AccessTargetName=" + $AccessTargetName)
    }
    if ($PolicyCategory) { 
        $Query += ("PolicyCategory=" + $PolicyCategory)
    }
    if ($ThreatDetectionAction) { 
        $Query += ("ThreatDetectionAction=" + $ThreatDetectionAction)
    }
    if ($ProcessCommandLine) { 
        $Query += ("ProcessCommandLine=" + $ProcessCommandLine)
    }
    if ($ProcessCertificateIssuer) { 
        $Query += ("ProcessCertificateIssuer=" + $ProcessCertificateIssuer)
    }
    if ($SourceProcessCommandLine) { 
        $Query += ("SourceProcessCommandLine=" + $SourceProcessCommandLine)
    }
    if ($SourceProcessUsername) { 
        $Query += ("SourceProcessUsername=" + $SourceProcessUsername)
    }
    if ($SourceProcessHash) { 
        $Query += ("SourceProcessHash=" + $SourceProcessHash)
    }
    if ($SourceProcessPublisher) { 
        $Query += ("SourceProcessPublisher=" + $SourceProcessPublisher)
    }
    if ($SourceProcessCertificateIssuer) { 
        $Query += ("SourceProcessCertificateIssuer=" + $SourceProcessCertificateIssuer)
    }
    if ($ExposedUsers) { 
        $Query += ("ExposedUsers=" + $ExposedUsers)
    }
    if ($Computer) {

        $Query += ("Computer=" + $Computer)

    }
    if ($FileQualifier) {

        $Query += ("FileQualifier=" + $FileQualifier)

    }
    if ($FileName) {

        $Query += ("FileName=" + $FileName)

    }

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