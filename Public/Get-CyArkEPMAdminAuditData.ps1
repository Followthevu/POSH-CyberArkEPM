function Get-CyArkEPMAdminAuditData(){
<# 
 .Synopsis 
  
 .Description 

 .Example 


#>
    Param(
        [parameter(Mandatory=$true)]
        [string]$SetID,
        [string]$Version

    )
	$uri = "https://${EpmServer}/EPM/API/Auth/EPM/Logon"

    $credential = get-credential

    #Password Object
    $Password = $credential.Password

    #i dont know what this does but its great, takes the secure string
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
    #point to the secure string password and convert back to usable plaintext
    $passplain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

	$Body = @{ 
        "Username" = $credential.username;
        "Password" = $passplain;
        "ApplicationID" = "POSH-CyberArkEPM" 
    }

    $adminaudituri = "https://${EpmServer}/EPM/API/Sets/${SetID}/AdminAudit"


	try {

        Write-Host "$(Get-Date) Authorizing with ${EpmServer}"

        $epmauth = Invoke-WebRequest -Uri $uri -ContentType "application/json" -Method "Post" -Body ( $Body | ConvertTo-Json )  

        $epmcontent = $epmauth.content | Convertfrom-Json

        Write-Host "$(Get-Date) Authorization Succeeded."
        
	} catch {
        # Dig into the exception to get the Response details.
        # Note that value__ is not a typo.
        $Err = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host $Err.Fields
        Write-Host $Err.ErrorCode
        Write-Host $Err.ErrorMessage
        Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription

        break
    }

    $TempHeader = @{ "Authorization" ="Basic " + $epmcontent.EPMAuthenticationResult }
    
    try {


        $epmadminaudit = Invoke-WebRequest -Uri $adminaudituri -ContentType "application/json" -Method "Get" -header $TempHeader

        $epmauditcontent = $epmadminaudit.content | Convertfrom-Json

        
    } catch {
        # Dig into the exception to get the Response details.
        # Note that value__ is not a typo.
        $Err = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host $Err.Fields
        Write-Host $Err.ErrorCode
        Write-Host $Err.ErrorMessage
        Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription

        break
    }

    return $epmauditcontent
}