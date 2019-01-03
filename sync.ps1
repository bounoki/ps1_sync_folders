
function Sync-Folder {
    [CmdletBinding()]
    Param(
        [string]$From,
        [string]$To,
        [string]$LogPath
    )

    # ログファイルにスレッド番号入れておく
    $th_id = [threading.thread]::CurrentThread.ManagedThreadId
    $LogPath = $LogPath -replace "__BOUNOKI-TOOL-TH-ID__", "th${th_id}"

    Write-Debug "ThID=${th_id},From=${From},To=${To},LogPath=${LogPath}"

    # /Lいれてあるよ
    Write-Information "ThID=${th_id} starts`t: From=${From},To=${To},LogPath=${LogPath}"
    robocopy.exe /B /L /MIR $From $To /r:2 /w:5 /LOG+:$LogPath /NP /NDL /TEE /XJD /XJF
    Write-Information "ThID=${th_id} finished`t: From=${From},To=${To},LogPath=${LogPath}"
}

workflow Sync-Parallel() {
    param(
        $sync_list,
        $log_dir_name
    )

    Write-Debug "(in-workflow) start."

    if (-not (Test-Path $log_dir_name)) {
        Write-Warning "(in-workflow) log dir not found.`n  before you run this script, create it.`n  log_dir_name=${log_dir_name}"
        return
    }
    else {
        Write-Verbose "(in-workflow) logs dir exists."
    }

    foreach -parallel ($each in $sync_list) {
        # foreach ($each in $sync_list) {
        Start-Sleep -s 3
        $datetime = (Get-Date -Format O).Replace("-", "").Replace(":", "")
        $log_file_name = "work-${datetime}-__BOUNOKI-TOOL-TH-ID__.log"
        $log_path = (Join-Path $log_dir_name $log_file_name)

        Write-Debug ("(in-workflow) " + ${each}['From'].ToString() + " => " + $each['To'].ToString())
        Sync-Folder -From $each["From"] -To $each["To"] -LogPath $log_path   
    }
}
