function New-CyarkEPMApp() {
<# 
.Synopsis 
Returns PS Object for the Application parameter when using New-CyarkEPMPolicy
.Description 
Returns PS Object for the Application parameter when using New-CyarkEPMPolicy

https://docs.cyberark.com/Product-Doc/OnlineHelp/EPM/11.5/en/Content/WebServices/AdvancedPolicyDefinition.htm
.Example 
New-CyarkEPMApp -Description "Application Description" -Checksum <HashofApplication> -FileName "Application.exe" 
#>
    Param(
        [string]$ApplicationID,
        [ValidateLength(1,1000)]
        [string]$Description,
        [ValidateSet($false,$true)]
        [bool]$Inheritable,
        [ValidateSet($false,$true)]
        [bool]$RestrictOpenSaveFileDialog,
        [string]$Checksum,
        [ValidateLength(1,250)]
        [string]$FileName,
        [ValidateSet('Exactly','Prefix','Contains','Wildcards','RegExp')]
        [string]$FileNameCompare,
        $FileSize,
        [ValidateLength(1,1024)]
        [ValidateSet('Fixed','Removable','ArbitraryPath')]
        [string]$Location,
        [ValidateLength(1,1024)]
        [string]$ArbitraryPath,
        [ValidateSet('WithSubfolders','NoSubFolders')]
        [string]$LocationCompare,
        [ValidateLength(1,512)]
        [string]$Owner,
        [ValidateLength(1,256)]
        [string]$OwnerSID,
        [ValidateLength(1,1024)]
        [string]$Arguments,
        [ValidateSet('ExactlyCaseSensitive','PrefixCaseSensitive','ContainsCaseSensitive','WildcardsCaseSensitive','RegExpCaseSensitive','ExactlyCaseInsensitive','PrefixCaseInsensitive','ContainsCaseInsensitive','WildcardsCaseInsensitive','RegExpCaseInsensitive')]
        [string]$ArgumentsCompare,
        [ValidateLength(1,1024)]
        [ValidateSet('AnySign','NotSigned','ArbitraryPublisher')]
        [string]$Signature,
        [ValidateLength(1,1024)]
        [string]$ArbitraryPublisher,
        [ValidateSet('Exactly','Prefix','Contains','Wildcards','RegExp')]
        [string]$SignatureCompare,
        [ValidateLength(1,256)]
        [string]$ProductName,
        [ValidateSet('Exactly','Prefix','Contains','Wildcards','RegExp')]
        [string]$ProductNameCompare,
        [ValidateLength(1,256)]
        [string]$FileDescription,
        [ValidateSet('Exactly','Prefix','Contains','Wildcards','RegExp')]
        [string]$FileDescriptionCompare,
        [ValidateLength(1,256)]
        [string]$Company,
        [ValidateSet('Exactly','Prefix','Contains','Wildcards','RegExp')]
        [string]$CompanyCompare,
        [string]$MinProductVersion,
        [string]$MaxProductVersion,
        [string]$MinFileVersion, 
        [string]$MaxFileVersion
    )

    [string]$Type = 'EXE'

    if (($Location) -and ($Location -eq 'ArbitraryPath')) {
        if ($ArbitraryPath) {$Location = $ArbitraryPath} else { Write-Host "`nPlease Provide a -ArbitraryPath"; break}
    }

    if (($Signature) -and ($Signature -eq 'ArbitraryPublisher')) {
        if ($ArbitraryPublisher) {$Location = $ArbitraryPath} else { Write-Host "`nPlease Provide a -ArbitraryPublisher"; break}
    }

    if($Checksum) {
        $Checksum = "SHA1:${Checksum}"
    }

    $App = [PSCustomObject]@{
 
            ApplicationID                  =    $ApplicationID
            Description                    =    $Description
            Type                           =    $Type
            Inheritable                    =    $Inheritable
            RestrictOpenSaveFileDialog     =    $RestrictOpenSaveFileDialog
            Checksum                       =    $Checksum
            FileName                       =    $FileName
            FileNameCompare                =    $FileNameCompare
            FileSize                       =    $FileSize
            Location                       =    $Location
            LocationCompare                =    $LocationCompare
            Owner                          =    $Owner
            OwnerSID                       =    $OwnerSID
            Arguments                      =    $Arguments
            ArgumentsCompare               =    $ArgumentsCompare
            Signature                      =    $Signature
            SignatureCompare               =    $SignatureCompare
            ProductName                    =    $ProductName
            ProductNameCompare             =    $ProductNameCompare
            FileDescription                =    $FileDescription
            FileDescriptionCompare         =    $FileDescriptionCompare
            Company                        =    $Company
            CompanyCompare                 =    $CompanyCompare
            MinProductVersion              =    $MinProductVersion
            MaxProductVersion              =    $MaxProductVersion
            MinFileVersion                 =    $MinFileVersion
            MaxFileVersion                 =    $MaxFileVersion

    }

    $App = $App | ForEach-Object {

        $NonEmptyProperties = $_.psobject.Properties | Where-Object {$_.Value} | Select-Object -ExpandProperty Name

        $_ | Select-Object -Property $NonEmptyProperties

    }

    return $App 

}