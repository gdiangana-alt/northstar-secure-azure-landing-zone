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

The next phase adds Azure monitoring and security operations capabilities, including Log Analytics, Microsoft Sentinel, diagnostic settings, detection content, and incident-response documentation.
