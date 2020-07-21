function New-CyarkEPMPolicyDetails() {

    Param(
        [parameter(Mandatory=$true)]
        [ValidateSet('AdvancedWinApp')]
        [string]$PolicyType,
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
        [parameter(Mandatory=$true)]
        $Applications

    )

    if (!$IncludeComputersInSet) { $IncludeComputersInSet = "" }
    if (!$IncludeComputerGroups) { $IncludeComputerGroups = "" }
    if (!$ExcludeComputersInSet) { $ExcludeComputersInSet = "" }
    if (!$ExcludeComputerGroups) { $ExcludeComputerGroups = "" }
    if (!$IncludeUsers) { $IncludeUsers = "" }
    if (!$IncludeUserGroups) { $IncludeUserGroups = "" }
    if (!$IncludeADComputerGroups) { $IncludeADComputerGroups = "" }
    if (!$ExcludeADComputerGroups) { $ExcludeADComputerGroups = "" }
    
    $PolicyDetails = [PSCustomObject]@{

        PolicyType                  =   $PolicyType
        Name                        =   $Name
        Action                      =   $Action
        Activation                  =   $Activation
        IncludeComputersInSet       =   @($IncludeComputersInSet)
        IncludeComputerGroups       =   @($IncludeComputerGroups)
        ExcludeComputersInSet       =   @($ExcludeComputersInSet)
        ExcludeComputerGroups       =   @($ExcludeComputerGroups)
        IncludeUsers                =   @($IncludeUsers)
        IncludeUserGroups           =   @($IncludeUserGroups)
        IncludeADComputerGroups     =   @($IncludeADComputerGroups)
        ExcludeADComputerGroups     =   @($ExcludeADComputerGroups)
        Applications                =   @($Applications)

    }

    <# $Object = [PSCustomObject]@{ 

            PolicyDetails   =   $PolicyDetails 

    } #>

    return $PolicyDetails 


}