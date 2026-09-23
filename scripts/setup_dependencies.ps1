$ErrorActionPreference = "Stop"

$RootDir = $PSScriptRoot | Split-Path -Parent
$ThirdParty = Join-Path $RootDir "third_party"

if (-not (Test-Path $ThirdParty)) {
    New-Item -ItemType Directory -Path $ThirdParty | Out-Null
}

$FreeRtosDir = Join-Path $ThirdParty "FreeRTOS"
if (-not (Test-Path $FreeRtosDir)) {
    git clone --depth 1 https://github.com/FreeRTOS/FreeRTOS-Kernel.git $FreeRtosDir
}

$CmsisF4Dir = Join-Path $ThirdParty "CMSIS_F4"
$Cmsis5Dir = Join-Path $ThirdParty "CMSIS_5"
$CmsisDir = Join-Path $ThirdParty "CMSIS"

if (-not (Test-Path $CmsisDir)) {
    git clone --depth 1 https://github.com/STMicroelectronics/cmsis_device_f4.git $CmsisF4Dir
    git clone --depth 1 https://github.com/ARM-software/CMSIS_5.git $Cmsis5Dir

    New-Item -ItemType Directory -Path (Join-Path $CmsisDir "Include") -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $CmsisDir "Device\ST\STM32F4xx\Include") -Force | Out-Null

    Copy-Item (Join-Path $Cmsis5Dir "CMSIS\Core\Include\*") (Join-Path $CmsisDir "Include") -Recurse -Force
    Copy-Item (Join-Path $CmsisF4Dir "Include\*") (Join-Path $CmsisDir "Device\ST\STM32F4xx\Include") -Recurse -Force
}

Write-Host "Dependencies ready in $ThirdParty"
