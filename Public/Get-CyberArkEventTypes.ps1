function Get-CyArkEventTypes(){

    $ThreatDetection = ("Attack","SuspiciousActivity")

    Write-Host "`nThreat Detection: "
    $ThreatDetection | foreach-object { Write-Host " - ${_}" }

    $ApplicationEvents = ("ElevationRequest","Trust","Installation","Launch","ManualRequest","Block","Access","Ransomware")

    Write-Host "`nApplication Events: "
    $ApplicationEvents | foreach-object { Write-Host " - ${_}" }

    $PolicyAudit = ("Trust","Installation","Launch","Block","Access","StartElevated","Computer")
    Write-Host "`nPolicy Audit: "
    $PolicyAudit | foreach-object { Write-Host " - ${_}" }

    break

}