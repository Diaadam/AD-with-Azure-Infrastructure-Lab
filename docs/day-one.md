# Day 1 Template — Hybrid AD + Zabbix Scope + Definition of Done

Copy this into `docs/day1.md` (or straight into the README) at the start of
every project. Day 1 is scope-only — just enough research to pick an approach,
not a study day. Keep every section short; if a section runs long, you're
scoping too much for a 14-day project.

---

## Project Name
`enterprise-hybrid-ad-with-azure-infrastructure-lab`

## One-Paragraph Spec
*What it does, in plain language — one paragraph, no bullet points.*

> Provision a repeatable hybrid Active Directory lab topology with Terraform and use Zabbix Server on Ubuntu as the monitoring platform for domain controllers, Linux hosts, network devices, and backup infrastructure.

## Boundary (What this project does NOT do)
*The fastest way to keep a 14-day project from becoming a 30-day one.*

- Does not: replace Active Directory domain design or recovery procedures.
- Does not: install Zabbix packages and database as part of the base Terraform module.
- Explicitly out of scope: production VPN/ExpressRoute, secrets, certificates, and unreviewed internet-facing monitoring endpoints.

## Definition of Done
*Concrete, checkable — not "it works," but what "working" means.*

- [ ] The lab networks include the documented office, monitoring, and backup segments.
- [ ] Ubuntu Zabbix Server is reachable at the monitoring host address.
- [ ] Zabbix agents or SNMP checks monitor the documented lab hosts.
- [ ] Deployed and reachable (state how: port-forward, ingress URL, etc.)
- [ ] README + architecture doc + troubleshooting log written (day 13)

## Success Criteria
*How you'll know it's actually done, not just "looks done."*

- Zabbix reports availability and basic health for the domain controllers, Ubuntu host, and backup server.
- Monitoring traffic is restricted to the Zabbix server or approved proxies.

## Chosen Approach
*The one decision that matters most for this project — pick it today, don't
relitigate it during the build.*

| Option considered | Why not chosen |
|---|---|
| Azure Monitor only | Does not match the requested portable lab monitoring workflow. |
| Prometheus/Grafana | Useful for metrics, but not the selected all-in-one infrastructure monitoring platform. |

**Going with:** Zabbix Server on Ubuntu
**Why:** It provides agent-based host monitoring, SNMP support, alerting, and a single operational view for the hybrid lab.

## Tools for This Project
*Pull from `tools-tracker.md` — reuse first, add new only if nothing covers it.*

- Plan/Scope: ...
- IaC: ...
- Build: ...
- CI/CD: ...
- Orchestration: ...
- Observability: Zabbix Server, Zabbix agents, and SNMP polling

## Day 1 Research (time-boxed)
*Just enough to pick the approach above — not a deep dive.*

- Looked at: the requested topology with HQ, branch, regional, monitoring, and backup segments.
- Landed on: Ubuntu Zabbix Server at `10.0.4.10` (see Chosen Approach).

---

## GitHub Setup Checklist (Day 1)

- [ ] Repo created from app-repo template
- [ ] Issues/Project board created (Todo / In Progress / Blocked / Done)
- [ ] Initial labels added (`bug`, `gap`, `infra`, per-service labels if applicable)
- [ ] `gitops/apps/<project-name>/` folder scaffolded in the shared gitops repo