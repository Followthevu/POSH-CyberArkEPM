function Get-CyArkEPMAuth(){
<# 
 .Synopsis 
  Retrieves credentials from cyberark for api service account.
 .Description 
  Retrieves credentials from cyberark for api service account.

 .Example 
  Get-CyArkEPMAuth

#>

    Param(
        [parameter(Mandatory=$true)]
        [ValidateSet('Credential','CyberArkAIMCertificate','WindowsAuth','CyberArkAIM')]
        $Method
    )


    $Uri = "https://${EpmServer}/EPM/API/Auth/EPM/Logon"

    $Username = $null
    $Password = $null

    Switch ($Method) {

        'Credential' {

            $Credentials = Get-Credential

            #i dont know what this does but its great, takes the secure string
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Credentials.Password)
            #point to the secure string password and convert back to usable plaintext
            $passplain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

            $Username = $Credentials.Username

            $Password = $passplain

            break
        }
        'CyberArkAIMCertificate' {

            #Certificates with Extensions
            $GrabCertsWithExt = Get-ChildItem Cert:\CurrentUser\My | ? { $_.Extensions }
            #Cert with Subject Alternative Names (SANs)
            $AuthCert = $GrabCertsWithExt | % { 
                #match users UPN to the Certificate
                if ($_.Extensions.Format(1)[9] -match ($env:USERNAME+'@'+$env:USERDNSDOMAIN) ) { 
                        $_ 
                }
            }

            try {
                
                Write-Host "$(Get-Date) Retrieving EPM Password"
                #Cyark API Call
                $CyarkAccount = Invoke-RestMethod -Uri "https://${CyberArkAIMServer}/AIMWebService/api/accounts?AppID=${CyberArkAppID}&Safe=${CyberArkSafeName}&Folder=Root&Object=${CyberArkObjectName}" -CertificateThumbprint $AuthCert.Thumbprint

                Write-Host "$(Get-Date) EPM Information has been retrieved"

            } catch {
                <# 
                This is the Error for invalid Cert from $Error[0], work on this later.
                {"ErrorCode":"APPAP306E","ErrorMsg":"Authentication error for App ID [MI_Prod_API]. Reason: APPAP133E Failed to verify application authentication data: CertificateSN \"6300014713a198178ce2f24f32000000014713\" is unauthorized"} 
                #>

                #take in current error
                $CurrentError = $_
                #this is the json error
                $ErrorDetails = $currenterror.ErrorDetails
                #display the exception and the Error details
                Write-Host "$(Get-Date) $($CurrentError.Exception)."
                #provide exit code 1
                #Exit 1
            }

            $Username = $global:ApiAccount
            #Password Object
            $Password = $CyarkAccount.Content

            break
        }
        'WindowsAuth' {

            break
        }
        'CyberArkAIM' {

            break
        } 
        default {
            break
        }

    }

    $Body = @{ 

        "Username" = $Username;
        "Password" = $Password;
        #This can be change to what ever?
        "ApplicationID" = "POSH-CyberArkEPM" 
    }


    try {

        Write-Host "$(Get-Date) Authorizing with ${EpmServer}"

        $epmauth = Invoke-WebRequest -Uri $uri -ContentType "application/json" -Method "Post" -Body ( $Body | ConvertTo-Json )  

        $epmcontent = $epmauth.content | Convertfrom-Json

        Write-Host "$(Get-Date) Authorization Succeeded."
        
    } catch {
        # Dig into the exception to get the Response details.
        # Note that value__ is not a typo.
        Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription

        break
    }

    Set-CyArkEPMHeader -AuthToken ($epmcontent.EPMAuthenticationResult)

}