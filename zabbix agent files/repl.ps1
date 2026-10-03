# ==============================================================================
# Script Name: repl.ps1 (Background Cached Version)
# ==============================================================================
Import-Module ActiveDirectory -ErrorAction SilentlyContinue

$CacheFile = "C:\Program Files\Zabbix Agent 2\scripts\repl_status.txt"

try {
    $LocalDC = (Get-ADDomainController -Discover).Name
    $PartnerMetadata = Get-ADReplicationPartnerMetadata -Target $LocalDC -ErrorAction Stop
    $FailedLinks = ($PartnerMetadata | Where-Object { $_.LastReplicationResult -ne 0 })

    if ($FailedLinks.Count -eq 0) {
        "Healthy" | Out-File -FilePath $CacheFile -Force
    } else {
        $Report = [System.Collections.Generic.List[string]]::new()
        $Report.Add("ALERT: Found $($FailedLinks.Count) replication failure(s) on DC [$LocalDC]")
        $Report.Add("--------------------------------------------------")

        foreach ($Link in $FailedLinks) {
            $Report.Add("Partner DC : $($Link.Partner.Split(',').Replace('CN=',''))")
            $Report.Add("Partition  : $($Link.NamingContext)")
            $Report.Add("Last Sync  : $($Link.LastReplicationSuccess)")
            $Report.Add("Error Code : $($Link.LastReplicationResult)")
            $Report.Add("--------------------------------------------------")
        }
        
        $Report | Out-File -FilePath $CacheFile -Force
    }
}
catch {
    "CRITICAL SCRIPT ERROR: $_" | Out-File -FilePath $CacheFile -Force
}
