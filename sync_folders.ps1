﻿$DebugPreference = "Continue"
$VerbosePreference = "Continue"
$InformationPreference ="Continue"

$base_name = (Split-Path -Parent $PSCommandPath)
. (Join-Path $base_name "sync.ps1")
$log_dir_name = (Join-Path $base_name "logs")

# robocopyする対象
$sync_list = @(
    @{From = "F:\bounoki"; To = "T:\bounoki"}
    # @{From = "F:\SkyDrive"; To = "T:\OneDrive"}

)

# ログフォルダーなかったら作っておく
if (-not (Test-Path $log_dir_name)) {
    Write-Verbose "log dir not found. Now create it."
    New-Item -ItemType Directory $log_dir_name -Confirm
}
else {
    Write-Verbose "logs dir exists."
}

# 実行
Measure-Command {
    Sync-Parallel $sync_list $log_dir_name
}