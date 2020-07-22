function New-CyarkEPMPolicyActivationSetting(){

    Param(
        [parameter(Mandatory=$False)]
        [ValidateSet('ActivateNow','ActivateOn','ActivateManually','Deactivate','DeactivateOn')]
        [string]$Activation,
        $ActivateDate,
        $DeactivateDate
    )

    $ActivationSetting = New-Object -TypeName psobject

    if ($ActivateDate) {

        $ActivateDate = Get-date $ActivateDate

        $ADate = [pscustomobject]@{

            Year        =        $ActivateDate.Year
            Month       =        $ActivateDate.Month
            Day         =        $ActivateDate.Day
            Hours       =        $ActivateDate.Hours
            Minutes     =        $ActivateDate.Minutes
            Seconds     =        $ActivateDate.Seconds

        }

        $ADate | Get-Member | ? { $_.membertype -eq "NoteProperty" }  | select -expand Name | ForEach-Object { if ($ADate.$_ -eq $null) { $ADate.$_ = 0 } }

    }
    
    if ($DeactivateDate) { 
        
        $DeactivateDate = Get-date $DeactivateDate

        $DDate = [pscustomobject]@{

            Year        =        $DeactivateDate.Year
            Month       =        $DeactivateDate.Month
            Day         =        $DeactivateDate.Day
            Hours       =        $DeactivateDate.Hours
            Minutes     =        $DeactivateDate.Minutes
            Seconds     =        $DeactivateDate.Seconds

        }

        $DDate| Get-Member | ? { $_.membertype -eq "NoteProperty" }  | select -expand Name | ForEach-Object { if ($ddate.$_ -eq $null) { $ddate.$_ = 0 } }

    }
    
    Switch ($Activation) {

        'ActivateNow' {

            $ActivationSetting | Add-Member -MemberType NoteProperty -Name "Enabled" -Value $True
            
            if ($DeactivateDate) {
                $ActivationSetting | Add-Member -MemberType NoteProperty -Name "DeactivateDate" -Value $DDate
            }
            
            break
        }
        'ActivateOn'  { 
            if ($ActivateDate) {
                
                $ActivationSetting | Add-Member -MemberType NoteProperty -Name "Enabled" -Value $True
                $ActivationSetting | Add-Member -MemberType NoteProperty -Name "ActivateDate" -Value $ADate
                
                if ($DeactivateDate) {
                    $ActivationSetting | Add-Member -MemberType NoteProperty -Name "DeactivateDate" -Value $DDate
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
                $ActivationSetting | Add-Member -MemberType NoteProperty -Name "DeactivateDate" -Value $DDate
            } else {
                Write-Host "`nPlease Provide an Activation Date using -DeactivateDate as a parameter"
                break
            }
            break

        }
        default { break }

    }

    return $ActivationSetting

}