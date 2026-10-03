$ErrorActionPreference = "Stop"
try {
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  $version = "${zabbix_agent_version}"
  $msiPath = "C:\zabbix_agent2.msi"
  $url = "https://cdn.zabbix.com/zabbix/binaries/stable/7.0/$version/zabbix_agent2-$version-windows-amd64-openssl.msi"

  Invoke-WebRequest -Uri $url -OutFile $msiPath -UseBasicParsing

  $msiArgs = '/i', $msiPath, '/qn', '/norestart', 'SERVER=${zabbix_server_ip}', 'SERVERACTIVE=${zabbix_server_ip}', 'ENABLEPATH=1'
  $process = Start-Process msiexec.exe -ArgumentList $msiArgs -Wait -PassThru
  if ($process.ExitCode -ne 0) { throw "msiexec exited $($process.ExitCode)" }

  New-NetFirewallRule -DisplayName 'Zabbix Agent' -Direction Inbound -LocalPort 10050 -Protocol TCP -Action Allow -ErrorAction SilentlyContinue
  Start-Service 'Zabbix Agent 2'

  "Installation completed with exit code: $($process.ExitCode)" | Out-File "C:\zabbix_install.log"
} catch {
  $_ | Out-File "C:\zabbix_install_error.log"
  throw
}