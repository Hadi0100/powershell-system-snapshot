# powershell-system-snapshot
Simple PowerShell script to collect a system information snapshot.

# Get-SystemSnapshot.ps1

A simple PowerShell script that collects basic system information and saves it to a timestamped text file.

## What it does

- Shows:
  - Computer name
  - Logged-in user
  - OS version
  - Last boot time
  - Top 5 processes by memory usage
  - Disk space summary

- Saves the report to:  
  `Documents\SystemSnapshots\SystemSnapshot-YYYYMMDD-HHMMSS.txt`

## How to run

1. Open **PowerShell**.
2. Navigate to the script folder:

   ```powershell
   Set-Location "C:\Path\To\Repo"

