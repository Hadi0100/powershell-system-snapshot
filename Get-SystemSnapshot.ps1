<# 
.SYNOPSIS
    Creates a simple system information snapshot.

.DESCRIPTION
    Gathers basic system info (computer name, user, OS, uptime, 
    top processes, disk space) and writes it to both the console 
    and a timestamped text file in the user's Documents\SystemSnapshots folder.

.NOTES
    Author: Your Name
    Date:   2025-12-09
#>

# 1. Prepare output folder & file
$timestamp   = Get-Date -Format "yyyyMMdd-HHmmss"
$documents   = [Environment]::GetFolderPath('MyDocuments')
$outputDir   = Join-Path $documents "SystemSnapshots"
$outputFile  = Join-Path $outputDir "SystemSnapshot-$timestamp.txt"

if (-not (Test-Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory | Out-Null
}

# 2. Collect basic info
$os          = Get-CimInstance Win32_OperatingSystem
$drives      = Get-PSDrive -PSProvider FileSystem
$processes   = Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 5

# 3. Build a text report
$reportLines = @()
$reportLines += "=== System Snapshot ==="
$reportLines += "Timestamp     : $(Get-Date)"
$reportLines += "Computer Name : $($env:COMPUTERNAME)"
$reportLines += "User          : $([Environment]::UserName)"
$reportLines += ""
$reportLines += "=== Operating System ==="
$reportLines += "Caption       : $($os.Caption)"
$reportLines += "Version       : $($os.Version)"
$reportLines += "Last Boot     : $($os.LastBootUpTime)"
$reportLines += ""
$reportLines += "=== Top 5 Processes by Memory ==="

foreach ($p in $processes) {
    $mb = [math]::Round($p.WorkingSet / 1MB, 2)
    $reportLines += "{0,-25} PID: {1,-6} Memory: {2,8} MB" -f $p.ProcessName, $p.Id, $mb
}

$reportLines += ""
$reportLines += "=== Disk Space Summary ==="

foreach ($d in $drives) {
    $freeGB  = [math]::Round($d.Free / 1GB, 2)
    $totalGB = [math]::Round($d.Used / 1GB + $d.Free / 1GB, 2)
    $reportLines += "{0,-10} Total: {1,6} GB   Free: {2,6} GB" -f $d.Name, $totalGB, $freeGB
}

# 4. Output to console
$reportLines | ForEach-Object { Write-Output $_ }

# 5. Save to file
$reportLines | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host ""
Write-Host "Snapshot saved to:`n$outputFile" -ForegroundColor Green
