#
# Example script to perform Fortify on Demand Static Code Analysis
#

# Parameters
param (
    [Parameter(Mandatory=$false)]
    [ValidateSet('classic','security','devops')]
    [string]$ScanPolicy = "classic",
    [Parameter(Mandatory=$false)]
    [switch]$SkipPDF,
    [Parameter(Mandatory=$false)]
    [switch]$SkipSSC
)

# Import local environment specific settings
$EnvSettings = $(ConvertFrom-StringData -StringData (Get-Content ".\.env" | Where-Object {-not ($_.StartsWith('#'))} | Out-String))
$AppName = $EnvSettings['FOD_APP_NAME']
$AppVersion = $EnvSettings['FOD_APP_REL_NAME']
$FoDApiUrl = $EnvSettings['FOD_API_URL']
$FoDClientId = $EnvSettings['FOD_API_KEY']
$FoDClientSecret = $EnvSettings['FOD_API_SECRET']

if ([string]::IsNullOrEmpty($AppName)) { throw "Application Name has not been set" }
if ([string]::IsNullOrEmpty($AppVersion)) { throw "Application Version has not been set" }
if ([string]::IsNullOrEmpty($FoDApiUrl)) { throw "FoD API URI has not been set" }
if ([string]::IsNullOrEmpty($FoDClientId)) { throw "FoD Client Id has not been set" }
if ([string]::IsNullOrEmpty($FoDClientSecret)) { throw "FoD Client Secret has not been set" }

# Run the translation and scan

& scancentral package -o fortifypackage.zip -bt none
& fcli fod session login --url $FoDApiUrl --client-id $FoDClientId --client-secret $FoDClientSecret --fod-session fcli-local
& fcli fod sast-scan start --release "$($AppName):$($AppVersion)" -f fortifypackage.zip --store curScan --fod-session fcli-local
& fcli fod sast-scan wait-for ::curScan:: --fod-session fcli-local
& fcli fod session logout --fod-session fcli-local

Write-Host Done.
