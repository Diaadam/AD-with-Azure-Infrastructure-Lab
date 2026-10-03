#to test agent can exec a user param
& "C:\Program Files\Zabbix Agent 2\zabbix_agent2.exe" -t adds-replication
#generate the initial file right away, run the task manually once:
Start-ScheduledTask -TaskName "Zabbix_AD_Replication_Check"
