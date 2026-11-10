param(
    [string]$RepositoryUrl = 'https://gitflic.ru/project/olegmaster69/ruasm.git',
    [string]$Branch = 'master'
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'Git is not installed or is not available in PATH.'
}
if (-not (Test-Path (Join-Path $Root 'README.md'))) {
    throw 'Run this script from the prepared RUASM repository.'
}
if ([string]::IsNullOrWhiteSpace($RepositoryUrl)) {
    throw 'RepositoryUrl must not be empty.'
}
if ([string]::IsNullOrWhiteSpace($Branch)) {
    throw 'Branch must not be empty.'
}

if (-not (Test-Path (Join-Path $Root '.git'))) {
    git init --initial-branch=$Branch
    if ($LASTEXITCODE -ne 0) { throw 'git init failed.' }
} else {
    $CurrentBranch = git branch --show-current
    if ($LASTEXITCODE -ne 0) { throw 'Could not determine the current Git branch.' }
    if ($CurrentBranch -ne $Branch) {
        git branch -M $Branch
        if ($LASTEXITCODE -ne 0) { throw "Could not rename the current branch to '$Branch'." }
    }
}

$ExistingRemote = git remote get-url origin 2>$null
if ($LASTEXITCODE -eq 0 -and $ExistingRemote -ne $RepositoryUrl) {
    throw "Remote origin already points to '$ExistingRemote'. Refusing to replace it automatically."
}
if ($LASTEXITCODE -ne 0) {
    git remote add origin $RepositoryUrl
    if ($LASTEXITCODE -ne 0) { throw 'Could not add the GitFlic remote.' }
}

git add --all
if ($LASTEXITCODE -ne 0) { throw 'git add failed.' }
git diff --cached --quiet
if ($LASTEXITCODE -eq 1) {
    git commit -m 'Publish RUASM 1.11.5 source and compiler package'
    if ($LASTEXITCODE -ne 0) { throw 'git commit failed. Configure git user.name and user.email if they are missing.' }
} elseif ($LASTEXITCODE -ne 0) {
    throw 'Could not inspect the Git index.'
}

git push --set-upstream origin $Branch
if ($LASTEXITCODE -ne 0) {
    throw 'git push failed. Check the GitFlic project URL, branch, access rights, and SSH or Git Credential Manager authentication. A non-empty remote branch is never overwritten automatically.'
}
Write-Host 'PASS: RUASM has been pushed to GitFlic.'
Write-Host (git rev-parse HEAD)
