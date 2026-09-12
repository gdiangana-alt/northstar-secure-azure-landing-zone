# NorthStar Secure Azure Landing Zone

Terraform-managed Azure landing zone demonstrating practical cloud-security architecture, network segmentation, governance, and identity controls.

## What This Project Demonstrates

- Secure Azure network design using Terraform
- Segmentation between management, web, and application tiers
- Governance through Azure Policy
- Least-privilege access using a managed identity and Reader RBAC
- Terraform drift detection and validation

## Architecture

- Resource group: NorthStar-Landing-Zone-RG
- Region: Canada Central
- Virtual network: northstar-lz-vnet
- Address space: 10.20.0.0/16
- Management subnet: 10.20.3.0/24
- Web subnet: 10.20.1.0/24
- Application subnet: 10.20.2.0/24
- Default outbound access: disabled on every subnet

## Security Controls

- Management-to-Web traffic is limited to HTTPS on TCP 443.
- Web-to-Application traffic is limited to TCP 8443.
- Each subnet has its own Network Security Group.
- Broad internet-facing workload access is not deployed.
- A custom Azure Policy audits resources missing the required Project tag.
- The policy is scoped to the NorthStar landing-zone resource group.
- The automation managed identity has Reader access only at resource-group scope.

## Validation

Terraform validation completed successfully.

Terraform compared the real Azure environment against the configuration and returned:

No changes. Your infrastructure matches the configuration.

## Scope

NorthStar is portfolio and lab work, not employer production experience.
Further planned work includes incident-response evidence, KQL threat-hunting queries, and enterprise identity/Zero Trust controls.


## Monitoring and Detection

- Subscription activity logs are routed to `NorthStar-SOC-Workspace` in Log Analytics.
- Microsoft Sentinel is enabled for the SOC workspace.
- Terraform manages the existing subscription diagnostic setting and Sentinel analytics rule.
- The scheduled rule `NorthStar - Failed Azure Control Plane Operation` detects failed control-plane operations in `NorthStar-Azure-RG`.
- Detection runs every five minutes, has Medium severity, and creates Sentinel incidents.
- Terraform validation and drift detection returned: `No changes. Your infrastructure matches the configuration.`

- Incident-response evidence: [Sentinel incident response case study](docs/sentinel-incident-case-study.md)
- Identity design: [NorthStar Identity and Zero Trust Design](docs/identity-zero-trust-design.md)
- Web-front design: [NorthStar Web Front End and WAF Architecture](docs/webfront-waf-architecture.md)

