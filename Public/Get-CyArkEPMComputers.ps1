function Get-CyArkEPMComputers() {
    <# Filter does not work yet#>
    Param(
        [string]$SetID,
        [int]$Offset,
        [ValidateRange(1,1000)]
        [int]$Limit,
        [string]$Filter
        #[string]$ComputerName,
        #[string]$Platform,
        #[string]$Status,
        #[ValidateSet('eq','in','contains')]
        #[string]$FilterOperator,


    )

    $ComputersUri = "https://${EpmServer}/EPM/API/Sets/${SetID}/Computers"


        if ($Offset -or $Limit -or $Filter) {
        
         $ComputersUri =  $ComputersUri + "?"
        
    }

    $Query = @()

    if ($Offset) {
        $Query += ("Offset=" + $Offset)
        #Write-Host "Uri will be: " + $Uri
    } 
    if ($Limit) {
        $Query += ("Limit=" + $Limit)
        #Write-Host "Uri will be: " + $Uri
    } 
    if ($Filter) {

        $Query += ("$filter=" + "'${Filter}'")

    }

    $QueryString = ($Query -join "&")

    $ComputersUri = $ComputersUri + $QueryString
   <# expiremental 
   if($ComputerName -or $Platform -or $Status) {

        $Filter = $null

        switch ($FilterOperator) {

            "eq" { $Filter = "ComputerName eq '${ComputerName}"; break }
            "in" { $Filter = "ComputerName in(${ComputerName})"; break}
            "contains" { $Filter = "contains(ComputernName, '${ComputerName}'"; break}
            default { "Specify Correct FilterOperator"; break}

        }

        $Query += ("$filter=" + $Filter)

    } #>

    try {

        $Computersrequest = Invoke-WebRequest -Uri $ComputersUri -ContentType "application/json" -Method "GET" -header $EpmHeader

        $Computerscontent =  $Computersrequest.content | Convertfrom-Json
        
    } catch {
        # Dig into the exception to get the Response details.
        # Note that value__ is not a typo.
        Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
    }   

    return $Computerscontent.computers

}