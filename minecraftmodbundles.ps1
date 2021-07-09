$cmdName = "7z"
if (!(Get-Command $cmdName -errorAction SilentlyContinue))
{
    Write-Warning "$cmdName is not installed or not added to PATH variable!"
    exit
}

$currentpath=(Get-Location)
Set-Location "$($env:appdata)/.minecraft/mods"

$path = "$($env:appdata)/.minecraft/mods/Bundles"
if(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}

$startingQuestion = Read-Host @"
[0] Create new bundle from current mods
[1] Load bundle
[2] Remove bundle
[3] List all bundles
[4] Remove all mods
[5] Remove all bundles

"@

if ($startingQuestion -eq 0) {
    $text = Read-Host "Name of bundle ?"
    $filepath = "./Bundles/$($text).zip"
    if (!(test-path $filepath)) {
        7z a -sdel "$($text).zip" * -xr!Bundles
        Move-Item "$($text).zip" "./Bundles/$($text).zip"
    }
} elseif ($startingQuestion -eq 1) {
    $filepath = "./Bundles"
    Write-Host ((Get-ChildItem -Path $filepath).BaseName) -ForegroundColor Cyan

    $prompt = Read-Host "Which one ?"
    if (!($prompt -eq "")) {
        Copy-Item "$($filepath)/$($prompt).zip" "./$($prompt).zip"
        7z x "$($prompt).zip"
        Remove-Item "$($prompt).zip"
    }
} elseif ($startingQuestion -eq 2) {
    $filepath = "./Bundles"
    Write-Host ((Get-ChildItem -Path $filepath).BaseName) -ForegroundColor Cyan
    
    $prompt = Read-Host "Which one ?"
    if (!($prompt -eq "")) {
        Remove-Item "$($filepath)/$($prompt).zip"
    }
} elseif ($startingQuestion -eq 3) {
    $filepath = "./Bundles"
    Write-Host ((Get-ChildItem -Path $filepath).BaseName) -ForegroundColor Cyan
} elseif ($startingQuestion -eq 4) {
    $prompt = Read-Host "Wipe all mods ? [y/n]"
    if ($prompt -eq "y") {
        Remove-Item -Path "./*" -Exclude "Bundles"
    }
} elseif ($startingQuestion -eq 5) {
    $prompt = Read-Host "Wipe all bundles ? [y/n]"
    if ($prompt -eq "y") {
        Remove-item -Path "./Bundles/*"
    }
}

Set-Location $currentpath
Read-Host "Press ENTER to exit"