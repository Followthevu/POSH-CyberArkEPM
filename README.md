# CyberArkEPM Powershell-Module

CyberArkEPM is a powershell module that communicates with a CyberArk EPM (Endpoint Privilege Manager) instance using their REST APIs.

Please Note: This Module is still incomplete.

Please see: https://docs.cyberark.com/Product-Doc/OnlineHelp/EPM/Latest/en/Content/LandingPages/LPDeveloper.htm

## Installation

First open 'CyberArkEPM.psm1'

If you are using CyberArkAIM to Access the user password please fill in:

```Powershell
#if using CyberArkAIM for authentication
$global:ApiAccount = ""
$global:CyberArkAIMServer = ""
$global:CyberArkSafeName = ""
$global:CyberArkAppID = ""
$global:CyberArkObjectName = ""
```

Fill in $global:EpmServer with one or more EPM Servers. If there are multiple servers please fill the variable in as an Array

```Powershell

$global:EpmServer = @("CyberArkEPM.Internal.Domain")

```

From Powershell:

```Powershell
cd [Path to Module folder]\CyberArkEPM

import-module .\CyberArkEPM.psm1

```

## Usage
For Help with the cmdlets please use the 'Get-Help' on the Cmdlet, please note that these are not complete yet.

To Authenticate: 
```Powershell
Get-CyarkEPMAuth -Method "Credential"
```

Viewing Sets from EPM:
```Powershell
# This Variable will have an Array of the Sets from the EPM
$Sets = Get-CyarkEPMSetsList

$Sets[0].id
```

## Contributing
Pull requests are welcomed. I am not experieced with github and git so there will be a delay for my response. For major changes, please open an issue first to discuss the proposed changes.

## License
Not Available