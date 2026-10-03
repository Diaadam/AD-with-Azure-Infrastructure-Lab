# ==============================================================================
# Script Name: check_ad_repl-int.ps1
# Description: Summarizes Active Directory replication errors for Zabbix Agent.
# Returns: Integer (0 = Healthy, >0 = Total count of failed replication links)
# ==============================================================================

try {
    # 1. Capture the system output of the repadmin tool cleanly
    $ReplSummary = repadmin /replsummary 2>$null | Out-String

    # 2. Extract digits that represent failures using a regular expression match
    $Matches = [regex]::Matches($ReplSummary, '(?i)largest delta.*?\s+(\d+)\s*/')
    
    $TotalErrors = 0
    foreach ($Match in $Matches) {
        if ($Match.Value -match '\d+') {
            $TotalErrors += [int]$Matches.Value
        }
    }

    # 3. Always return a strict integer back to Zabbix
    Write-Output $TotalErrors
}
catch {
    # If the execution breaks completely, output a mock failure count so Zabbix alerts you
    Write-Output 999
}
