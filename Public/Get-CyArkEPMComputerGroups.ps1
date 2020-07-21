function Get-CyArkEPMComputerGroups() {
    <# #>
    Param(
        [string]$SetID
    )

    $ComputerGroupsUri = "https://${EpmServer}/EPM/API/Sets/${SetID}/ComputerGroups"

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