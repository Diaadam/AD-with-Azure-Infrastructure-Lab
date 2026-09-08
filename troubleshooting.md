# Troubleshooting log

Record the symptom, evidence, root cause, fix, and outreach wording for each issue. Keep entries factual and reproducible.

## Template

### YYYY-MM-DD - Short title

- **Symptom:**
- **Evidence:**
- **Root cause:**
- **Fix:**
- **Prevention:**
- **Outreach note:**

## Known gaps

### Zabbix monitoring implementation

- **Gap:** The target monitoring platform is Zabbix, but the current Terraform only provisions optional Ubuntu compute and does not install Zabbix Server, its database, agents, or SNMP checks.
- **Impact:** Infrastructure can be created before monitoring becomes operational.
- **Fix:** Add an idempotent configuration step for Ubuntu Zabbix Server at `10.0.4.10`, then enroll the domain controllers, Linux hosts, and backup server.
- **Prevention:** Treat Zabbix templates, host groups, alert thresholds, and firewall rules as versioned configuration.
- **Outreach note:** Confirm Zabbix version, database engine, retention period, alert channels, and ownership of agent credentials with the operations team.

### Initial scaffold - follow-up work required

- **Gap:** Domain controller promotion and hybrid connectivity are not automated.
- **Impact:** The current Terraform creates the landing-zone primitives only.
- **Next step:** Add a reviewed VPN or ExpressRoute design, then automate AD DS configuration with an idempotent configuration tool.
- **Outreach note:** Confirm network ports, DNS ownership, identity licensing, and recovery objectives with the platform and identity teams before implementation.
