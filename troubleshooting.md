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

### Initial scaffold - follow-up work required

- **Gap:** Domain controller promotion and hybrid connectivity are not automated.
- **Impact:** The current Terraform creates the landing-zone primitives only.
- **Next step:** Add a reviewed VPN or ExpressRoute design, then automate AD DS configuration with an idempotent configuration tool.
- **Outreach note:** Confirm network ports, DNS ownership, identity licensing, and recovery objectives with the platform and identity teams before implementation.
