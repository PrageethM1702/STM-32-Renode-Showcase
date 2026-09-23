$ErrorActionPreference = "Stop"

$RootDir = Split-Path $PSScriptRoot -Parent
$BuildDir = Join-Path $RootDir "build"
$Target = "firmware"

$FreeRtosDir = Join-Path $RootDir "third_party\FreeRTOS"
$CmsisDir = Join-Path $RootDir "third_party\CMSIS"

$CC = "arm-none-eabi-gcc"
$OBJCOPY = "arm-none-eabi-objcopy"
$SIZE = "arm-none-eabi-size"

if (-not (Get-Command $CC -ErrorAction SilentlyContinue)) {
    Write-Error "arm-none-eabi-gcc not found on PATH. Install the ARM GNU toolchain and reopen your terminal."
    exit 1
}

if (-not (Test-Path $FreeRtosDir)) {
    Write-Error "FreeRTOS not found at $FreeRtosDir. Run scripts\setup_dependencies.ps1 first."
    exit 1
}

$Sources = @(
    "src\main.c",
    "src\sensor_task.c",
    "src\uart_driver.c",
    "src\adc_driver.c",
    "src\led_driver.c",
    "src\system_clock.c",
    "src\syscalls.c",
    "src\startup_stm32f407.s",
    "third_party\FreeRTOS\tasks.c",
    "third_party\FreeRTOS\queue.c",
    "third_party\FreeRTOS\list.c",
    "third_party\FreeRTOS\timers.c",
    "third_party\FreeRTOS\portable\GCC\ARM_CM4F\port.c",
    "third_party\FreeRTOS\portable\MemMang\heap_4.c"
)

$Includes = @(
    "-Iinc",
    "-I$FreeRtosDir\include",
    "-I$FreeRtosDir\portable\GCC\ARM_CM4F",
    "-I$CmsisDir\Include",
    "-I$CmsisDir\Device\ST\STM32F4xx\Include"
)

$CFlags = @(
    "-mcpu=cortex-m4", "-mthumb", "-mfpu=fpv4-sp-d16", "-mfloat-abi=hard",
    "-DSTM32F407xx", "-O2", "-g", "-Wall", "-Wextra",
    "-ffunction-sections", "-fdata-sections"
) + $Includes

$LdFlags = @(
    "-mcpu=cortex-m4", "-mthumb", "-mfpu=fpv4-sp-d16", "-mfloat-abi=hard",
    "-Tscripts\stm32f407.ld", "-Wl,--gc-sections", "-nostartfiles", "-specs=nano.specs"
)

if (-not (Test-Path $BuildDir)) {
    New-Item -ItemType Directory -Path $BuildDir | Out-Null
}

$ObjectFiles = @()

foreach ($src in $Sources) {
    $srcPath = Join-Path $RootDir $src
    $objRelative = "$src.o"
    $objPath = Join-Path $BuildDir $objRelative
    $objDir = Split-Path $objPath -Parent

    if (-not (Test-Path $objDir)) {
        New-Item -ItemType Directory -Path $objDir -Force | Out-Null
    }

    Write-Host "Compiling $src"
    & $CC @CFlags -c $srcPath -o $objPath
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Compilation failed for $src"
        exit 1
    }

    $ObjectFiles += $objPath
}

$ElfPath = Join-Path $BuildDir "$Target.elf"

Write-Host "Linking $Target.elf"
& $CC @LdFlags @ObjectFiles -o $ElfPath
if ($LASTEXITCODE -ne 0) {
    Write-Error "Linking failed"
    exit 1
}

& $SIZE $ElfPath

Write-Host "Build complete: $ElfPath"