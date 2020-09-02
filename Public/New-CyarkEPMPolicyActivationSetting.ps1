function New-CyarkEPMPolicyActivationSetting() {
<# 
.Synopsis 
Returns PS Object for the Activation Parameter needed for a new EPM Policy
.Description 
Returns PS Object for the Activation Parameter needed for a new EPM Policy

https://docs.cyberark.com/Product-Doc/OnlineHelp/EPM/11.5/en/Content/WebServices/AdvancedPolicyDefinition.htm
.Example 
New-CyarkEPMPolicyActivationSetting -Activation "ActivateNow"
.Example 
New-CyarkEPMPolicyActivationSetting -Activation "ActivateOn" -ActivationDate "02/08/2020 8PM"
.Example 
New-CyarkEPMPolicyActivationSetting -Activation "Deactivate"
#>
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
            Hours       =        $ActivateDate.Hour
            Minutes     =        $ActivateDate.Minute
            Seconds     =        $ActivateDate.Second

        }

        $ADate | Get-Member | ? { $_.membertype -eq "NoteProperty" }  | select -expand Name | ForEach-Object { if ($ADate.$_ -eq $null) { $ADate.$_ = 0 } }

    }
    
    if ($DeactivateDate) { 
        
        $DeactivateDate = Get-date $DeactivateDate

        $DDate = [pscustomobject]@{

            Year        =        $DeactivateDate.Year
            Month       =        $DeactivateDate.Month
            Day         =        $DeactivateDate.Day
            Hours       =        $DeactivateDate.Hour
            Minutes     =        $DeactivateDate.Minute
            Seconds     =        $DeactivateDate.Second

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