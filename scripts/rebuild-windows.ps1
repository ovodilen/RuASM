$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$Compiler = Join-Path $Root 'bin\windows-x86_64\ruasm.exe'
$Source = Join-Path $Root 'src\generated\windows\ruasm-windows.asm'
$Build = Join-Path $Root 'build'
$Output = Join-Path $Build 'ruasm.exe'
$Expected = Join-Path $Root 'bin\windows-x86_64\ruasm.exe'

New-Item -ItemType Directory -Force $Build | Out-Null
& $Compiler $Source -o $Output --quiet
if ($LASTEXITCODE -ne 0) { throw "RUASM exited with code $LASTEXITCODE" }
$ExpectedHash = (Get-FileHash -LiteralPath $Expected -Algorithm SHA256).Hash
$ActualHash = (Get-FileHash -LiteralPath $Output -Algorithm SHA256).Hash
if ($ExpectedHash -ne $ActualHash) { throw 'Rebuilt Windows compiler differs from the distributed binary.' }
Write-Host 'PASS: Windows compiler rebuilt byte-for-byte.'
