function Get-CyArkEPMAdminAudit() {
    <# doesnt work at the moment#>
    Param(
        [string]$SetID
    )

    $AdminAuditUri = "https://${EpmServer}/EPM/API/Sets/${SetID}/AdminAudit"

    try {

        $AdminAuditrequest = Invoke-WebRequest -Uri $AdminAuditUri -ContentType "application/json" -Method "GET" -header $EpmHeader

        #$AdminAuditcontent =  $AdminAuditrequest.content | Convertfrom-Json
        
    } catch {
        # Dig into the exception to get the Response details.
        # Note that value__ is not a typo.
        Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
    }   

    return $AdminAuditrequest

}