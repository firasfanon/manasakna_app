$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")
$keytool = Get-Command keytool -ErrorAction SilentlyContinue
if (-not $keytool) { throw "keytool not found. Install a JDK first." }
keytool -genkey -v `
  -keystore android/upload-keystore.jks `
  -storetype JKS `
  -keyalg RSA `
  -keysize 2048 `
  -validity 10000 `
  -alias munasakna_upload
Copy-Item android/key.properties.example android/key.properties -Force
Write-Host "Created android/upload-keystore.jks. Edit android/key.properties with the passwords you entered."
