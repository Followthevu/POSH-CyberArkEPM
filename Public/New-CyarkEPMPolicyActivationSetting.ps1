function New-CyarkEPMPolicyActivationSetting(){

    Param(
        [parameter(Mandatory=$False)]
        [ValidateSet('ActivateNow','ActivateOn','ActivateManually','Deactivate','DeactivateOn')]
        [string]$Activation,
        [string]$ActivateDate,
        [string]$DeactivateDate
    )

    $ActivationSetting = New-Object -TypeName psobject

    if ($ActivateDate) { $ActivateDate = Get-date $ActivateDate -Format s }
    
    if ($DeactivateDate) { $DeactivateDate = Get-date $DeactivateDate -Format s }
    
    Switch ($Activation) {

        'ActivateNow' { 
            $ActivationSetting | Add-Member -MemberType NoteProperty -Name "Enabled" -Value $True
            if ($DeactivateDate) {
                $ActivationSetting | Add-Member -MemberType NoteProperty -Name "DeactivateDate" -Value $DeactivateDate
            }
            break
        }
        'ActivateOn'  { 
            if ($ActivateDate) {
                $ActivationSetting | Add-Member -MemberType NoteProperty -Name "Enabled" -Value $True
                $ActivationSetting | Add-Member -MemberType NoteProperty -Name "ActivateDate" -Value $ActivateDate
                if ($DeactivateDate) {
                    $ActivationSetting | Add-Member -MemberType NoteProperty -Name "DeactivateDate" -Value $DeactivateDate
                }
            } else {
                Write-Host "`nPlease Provide an Activation Date using -ActivateDate as a parameter"
                break
            }
            break
        }
        'ActivateManually' { 
            $ActivationSetting | Add-Member -MemberType NoteProperty -Name "Enabled" -Value $False
            break 
        }
        'Deactivate' { 
            $ActivationSetting | Add-Member -MemberType NoteProperty -Name "Enabled" -Value $False
            break 
        }
        'DeactivateOn' { 
            if ($DeactivateDate) {
                $ActivationSetting | Add-Member -MemberType NoteProperty -Name "DeactivateDate" -Value $DeactivateDate
            } else {
                Write-Host "`nPlease Provide an Activation Date using -DeactivateDate as a parameter"
                break
            }
        break
        }

    }

    return $ActivationSetting

}