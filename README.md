# CyberArkEPM Powershell-Module

CyberArkEPM is a Powershell module that communicates with a CyberArk EPM (Endpoint Privilege Manager) instance using CyberArk REST APIs.

Please Note: This module is still incomplete.

API Version: 11.5

Please see: https://docs.cyberark.com/Product-Doc/OnlineHelp/EPM/11.5/en/Content/LandingPages/LPDeveloper.htm

## Installation

First open 'CyberArkEPM.psm1'

If you are using CyberArkAIM to access the service account password please fill in the following in the CyberArkEPM.psm1:

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
For help with the cmdlets please use the 'Get-Help' on the Cmdlet, please note that these are not complete yet.

To Authenticate: 
```Powershell
Get-CyarkEPMAuth -Method "Credential"
```

If you would like the module to trigger authentication immediately, you may add the above line to the end of the psm1 file before import.

Viewing Sets from EPM:
```Powershell
# This Variable will have an Array of the Sets from the EPM
$Sets = Get-CyarkEPMSetsList

$Sets[0].id
```

## Contributing
Pull requests are welcomed. I am not experienced with github and git so there will be a delay with my response. For major changes, please open an issue first to discuss the proposed changes.

## Actions

### Created actions for

- EPM authentication
- Get EPM version
- Get sets list
- Get aggregated events
- Get raw events
- Get raw event details
- Get policies
- Get policy details
- Get computer groups
- Get computers

### Not worked on yet/incomplete

- Windows authentication
- Update policy
- Update ransomware mode

## License
MIT License, please see 'LICENSE'