# Troubleshooting Summary: Terraform, Zabbix, and Azure VM

This document outlines the errors encountered during the deployment and configuration of an Azure Bastion, Zabbix Server (on Linux), and Zabbix Agent (on Windows), along with the steps taken to resolve them.

## 1. Terraform Deprecation Warning (HTTP Provider)

**Error Message:**

> `Warning: Deprecated attribute`
> `The attribute "body" is deprecated. Refer to the provider documentation for details.`

**Context:**
Attempting to dynamically fetch the local machine's public IP address using the `http` provider in Terraform to inject into an NSG rule (`data.http.my_ip.body`).

**Resolution:**
Updated the Terraform code to use the new `.response_body` attribute instead of `.body`.

```
locals {
  my_ip = chomp(data.http.my_ip.response_body)
}

```

## 2. Windows Service Not Found (Zabbix Agent 2)

**Error Message:**

> `Get-Service : Cannot find any service with service name 'Zabbix Agent 2'.`
> `CategoryInfo : ObjectNotFound: (Zabbix Agent 2:String) [Get-Service], ServiceCommandException`

**Context:**
Running PowerShell commands on a Windows VM to check the status of the newly installed Zabbix Agent 2.

**Resolution:**
The `-Name` parameter queries the *internal* service name (which often lacks spaces, e.g., `ZabbixAgent2`), not the display name. The solution was to use wildcards or search by display name to find the exact service ID:

```
Get-Service *zabbix*
# OR
Get-Service -DisplayName "*zabbix*"

```

## 3. Failed Cloud-init Execution on Azure VM

**Issue:**
The initial `cloudinit.yaml` script failed during the Azure VM creation (resulting in incomplete Zabbix installation). The goal was to fix and re-run the configuration without redeploying the entire VM.

**Resolution:**
Running a simple reboot or `cloud-init clean` would cause Azure to re-inject the original broken script. To fix this locally:

1. Created a fixed configuration file: `/etc/cloud/cloud.cfg.d/99-fixed-cloudinit.cfg`.

2. Cleaned the cloud-init state: `sudo cloud-init clean`.

3. Manually triggered the cloud-init phases to apply the fixes without rebooting:

   ```
   sudo cloud-init init
   sudo cloud-init modules --mode=config
   sudo cloud-init modules --mode=final
   
   ```

## 4. Zabbix Web Interface 404 Error (Nginx)

**Error Message:**

> `404 Not Found - nginx/1.18.0 (Ubuntu)` (Shown in web browser at `http://10.1.7.20/zabbix`)

**Context:**
Attempting to access the Zabbix frontend through an Azure Bastion connection after the cloud-init installation failed. Nginx was running but couldn't find the Zabbix files at the `/zabbix` path.

**Resolution:**
Because the automated setup didn't finish, Nginx was unconfigured.

1. Checked the root URL (`http://10.1.7.20/`) as Nginx often serves Zabbix at the root instead of a subfolder.

2. Manually configured the Zabbix Nginx block in `/etc/zabbix/nginx.conf` by uncommenting:

   ```
   listen 8080; # or 80
   server_name 10.1.7.20;
   
   ```

3. Restarted the web and PHP services to apply changes:

   ```
   sudo systemctl restart nginx php8.1-fpm
   
   ```