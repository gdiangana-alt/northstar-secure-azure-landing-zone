# NorthStar Secure Azure Landing Zone

Terraform-managed Azure security architecture demonstrating network segmentation, governance, identity, SOC monitoring, protected web delivery, and operational validation.

## What This Project Demonstrates

- Modular Terraform infrastructure managed through a locked Azure remote state backend
- Segmented Azure networking with dedicated management, web, application, and WAF subnets
- Azure Policy governance and least-privilege group-based RBAC
- Microsoft Sentinel monitoring, analytics, incident handling, and KQL-based evidence
- Application Gateway WAF protection for a managed Linux App Service workload
- Azure Key Vault access through managed identity and Azure RBAC
- Terraform validation and drift detection against the live Azure environment

## Deployed Architecture

```mermaid
flowchart TB
    Internet["Internet"] --> Gateway["Application Gateway WAF"]
    Gateway --> App["Linux App Service"]
    App --> Vault["Azure Key Vault"]
    Gateway --> SOC["Log Analytics and Microsoft Sentinel"]
```

- Region: Canada Central
- Resource group: `NorthStar-Landing-Zone-RG`
- Virtual network: `northstar-lz-vnet` (`10.20.0.0/16`)
- Management subnet: `10.20.3.0/24`
- Web subnet: `10.20.1.0/24`
- Application subnet: `10.20.2.0/24`
- Dedicated WAF subnet: `10.20.10.0/24`
- Default outbound access: disabled on every subnet

## Security Controls

- Management-to-Web traffic is limited to HTTPS on TCP 443.
- Web-to-Application traffic is limited to TCP 8443.
- Each tier has a dedicated Network Security Group.
- Azure Policy audits resources missing the required `Project` tag.
- Cloud Admins receive Contributor only at landing-zone resource-group scope.
- Security Analysts and the automation managed identity receive Reader only at landing-zone resource-group scope.
- Application Gateway uses OWASP CRS 3.2 in WAF Detection mode.
- The App Service allows direct access only from the dedicated WAF subnet and denies all other direct ingress.
- The App Service uses HTTPS, disables FTP and Web Deploy basic authentication, and has a system-assigned managed identity.
- Key Vault uses Azure RBAC; the web application has only the `Key Vault Secrets User` role at vault scope.
- Subscription activity and Application Gateway diagnostics are routed to `NorthStar-SOC-Workspace`.

## Monitoring and Detection

- Microsoft Sentinel is enabled for the SOC workspace.
- Terraform manages the subscription diagnostic setting and Sentinel analytics rule.
- `NorthStar - Failed Azure Control Plane Operation` detects failed control-plane operations in `NorthStar-Azure-RG`.
- Application Gateway access, performance, and WAF logs are collected in Log Analytics.
- `NorthStar - Application Gateway WAF Rule Match` creates Low-severity Sentinel alerts with WAF context and groups related alerts into one-hour incidents.
- Controlled validation confirmed that WAF inspection events reach the SOC workspace.

## Validation Evidence

- Terraform validation completed successfully.
- Terraform drift detection returned: `No changes. Your infrastructure matches the configuration.`
- Application Gateway backend health reported the App Service as `Healthy`.
- HTTP requests to `northstar.guydiangana.com` return a permanent `301` redirect to HTTPS.
- HTTPS requests to `northstar.guydiangana.com` return `200 OK` with a trusted Let’s Encrypt certificate.
- A controlled request triggered OWASP rule `920350`; the WAF logged it as `Matched` in Log Analytics.

## Documentation

- [Cost control and teardown runbook](docs/cost-control-and-teardown.md)
- [TLS and WAF operational validation](docs/tls-and-waf-operational-validation.md)
- [Sentinel incident response case study](docs/sentinel-incident-case-study.md)
- [Identity and Zero Trust design](docs/identity-zero-trust-design.md)
- [Web front end and WAF architecture](docs/webfront-waf-architecture.md)
- [Implementation decisions and lessons learned](docs/implementation-decisions.md)
- [Application Gateway WAF log validation](docs/waf-log-validation.md)

## Certificate Lifecycle Limitation

The public endpoint is available at `https://northstar.guydiangana.com` through Application Gateway WAF. HTTP is permanently redirected to HTTPS, and the App Service backend is reached over HTTPS.

The current certificate was issued through manual DNS validation. The remaining operational improvement is automated DNS validation and certificate renewal before the December 12, 2026 expiry date.

## Scope

NorthStar is portfolio and lab work, not employer production experience.
