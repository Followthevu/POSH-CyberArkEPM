function New-CyarkEPMPolicyDetails() {
<# 
.Synopsis 
This method creates a new EPM policy.
.Description 
This method creates a new EPM policy.

- $IncludeComputersInSet: #Array of Agent IDs, If neither "IncludeComputersInSet" nor "IncludeComputerGroups" are specified, the policy will be delivered to all computers in the set.
- $IncludeComputerGroups: #Arrayof Internal EPM ID of computer group, If neither "IncludeComputersInSet" nor "IncludeComputerGroups" are specified, the policy will be delivered to all computers in the set.
- $ExcludeComputersInSet: #Array, The excluded computers will be removed from the computers set in "IncludeComputersInSet" and "IncludeComputerGroups"
- $ExcludeComputerGroups: #Array, The excluded computers will be removed from the computers set in "IncludeComputersInSet" and "IncludeComputerGroups"
- $IncludeUsers: #Array of usernames 'domain\username' or sids, If neither "IncludeUsers" nor "IncludeUserGroups" are specified, the policy will apply to processes launched by any user.
- $IncludeUserGroups: #Arrayof Groupnames 'domain\groupname' or SIDS, If neither "IncludeUsers" nor "IncludeUserGroups" are specified, the policy will apply to processes launched by any user.
- $IncludeADComputerGroups: #Array, If "IncludeUserGroups" is not specified, the policy will apply on any computer it is delivered to
- $ExcludeADComputerGroups: #Array, The excluded AD Computer Groups will be removed from the computers set in "IncludeADComputerGroups")

.Example 
New-CyarkEPMPolicyDetails -PolicyType AdvancedWinApp -Name <Name of Policy> -IncludeComputersInSet <comma separated list of computer id> -action Trust -activation <Activation object from New-CyarkEPMPolicyActivationSetting>
#>
    Param(
        [parameter(Mandatory=$true)]
        [ValidateLength(1,512)]
        [string]$Name,
        [parameter(Mandatory=$true)]
        [ValidateSet('NormalRun','Block','Elevate','Trust')]
        [string]$Action,
        [parameter(Mandatory=$true)]
        $Activation,    #Object
        $IncludeComputersInSet, #Array of Agent IDs, If neither "IncludeComputersInSet" nor "IncludeComputerGroups" are specified, the policy will be delivered to all computers in the set.
        $IncludeComputerGroups, #Arrayof Internal EPM ID of computer group, If neither "IncludeComputersInSet" nor "IncludeComputerGroups" are specified, the policy will be delivered to all computers in the set.
        $ExcludeComputersInSet, #Array, The excluded computers will be removed from the computers set in "IncludeComputersInSet" and "IncludeComputerGroups"
        $ExcludeComputerGroups, #Array, The excluded computers will be removed from the computers set in "IncludeComputersInSet" and "IncludeComputerGroups"
        $IncludeUsers, #Array of usernames 'domain\username' or sids, If neither "IncludeUsers" nor "IncludeUserGroups" are specified, the policy will apply to processes launched by any user.
        $IncludeUserGroups, #Arrayof Groupnames 'domain\groupname' or SIDS, If neither "IncludeUsers" nor "IncludeUserGroups" are specified, the policy will apply to processes launched by any user.
        $IncludeADComputerGroups, #Array, If "IncludeUserGroups" is not specified, the policy will apply on any computer it is delivered to
        $ExcludeADComputerGroups, #Array, The excluded AD Computer Groups will be removed from the computers set in "IncludeADComputerGroups")
        [parameter(Mandatory=$false)]
        $Applications

    )

    [string]$PolicyType = "AdvancedWinApp"

    if ($IncludeComputersInSet) {

        $IncludeComputersInSet = ConvertTo-IdObjects -IDs $IncludeComputersInSet

    } else {

        Write-Host "`nIf you would like to apply the policy to all computers please use '@()' as a value for 'IncludeComputersInSet'`n"
        break

    }

    if ($IncludeComputerGroups) {
        
        $IncludeComputerGroups = ConvertTo-IdObjects -IDs $IncludeComputerGroups

    } else { $IncludeComputerGroups = @() }

    if ($ExcludeComputersInSet) {
        
        $ExcludeComputersInSet = ConvertTo-IdObjects -IDs $ExcludeComputersInSet

    } else { $ExcludeComputersInSet = @() }

    if ($ExcludeComputerGroups) {
        
        $ExcludeComputerGroups = ConvertTo-IdObjects -IDs $ExcludeComputerGroups

    } else { $ExcludeComputerGroups = @() }

    if ($IncludeUsers) {
        
        $IncludeUsers = ConvertTo-IdObjects -IDs $IncludeUsers

    } else { $IncludeUsers = @() }

    if ($IncludeUserGroups) {
        
        $IncludeUserGroups = ConvertTo-IdObjects -IDs $IncludeUserGroups

    } else { $IncludeUserGroups = @() }

    if ($IncludeADComputerGroups) {
        
        $IncludeADComputerGroups = ConvertTo-IdObjects -IDs $IncludeADComputerGroups

    } else { $IncludeADComputerGroups = @() }

    if ($ExcludeADComputerGroups) {
        
        $ExcludeADComputerGroups = ConvertTo-IdObjects -IDs $ExcludeADComputerGroups

    } else { $ExcludeADComputerGroups = @() }

    $PolicyDetails = [PSCustomObject]@{

        PolicyType                  =   $PolicyType
        Name                        =   $Name
        Action                      =   $Action
        Activation                  =   $Activation
        IncludeComputersInSet       =   @($IncludeComputersInSet)
        IncludeComputerGroups       =   $IncludeComputerGroups
        ExcludeComputersInSet       =   $ExcludeComputersInSet
        ExcludeComputerGroups       =   $ExcludeComputerGroups
        IncludeUsers                =   $IncludeUsers
        IncludeUserGroups           =   $IncludeUserGroups
        IncludeADComputerGroups     =   $IncludeADComputerGroups
        ExcludeADComputerGroups     =   $ExcludeADComputerGroups
        Applications                =   @($Applications)

    }

    return $PolicyDetails 

}