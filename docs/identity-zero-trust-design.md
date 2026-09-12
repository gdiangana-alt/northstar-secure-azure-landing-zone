# NorthStar Identity and Zero Trust Design

## Objective

Apply least privilege through Entra security groups, scoped Azure RBAC, managed identities, and identity-governance design.

## Identity Personas

| Group | Purpose | Azure access |
|---|---|---|
| NorthStar-Employees | Standard organizational users | No Azure infrastructure access |
| NorthStar-App-Developers | Application delivery personas | Application-scoped access only when the web workload is deployed |
| NorthStar-Security-Analysts | Monitoring and investigation personas | Reader on the landing-zone resource group |
| NorthStar-Cloud-Admins | Infrastructure administration personas | Contributor on the landing-zone resource group |

## Implemented Controls

- Group-based RBAC is managed through Terraform.
- Cloud Admins receive Contributor only at `NorthStar-Landing-Zone-RG`; they do not receive subscription-wide Owner access.
- Security Analysts receive Reader only at `NorthStar-Landing-Zone-RG`.
- The automation managed identity has Reader access only at the same resource-group scope.
- Existing Entra groups are referenced as Terraform data sources so Terraform does not accidentally alter group membership or lifecycle.

## Zero Trust Design Decisions

- Access is granted to groups, not directly to individual users.
- Administrative access is scoped to the smallest practical Azure boundary.
- Application users will authenticate through Microsoft Entra ID.
- Application secrets will be replaced by managed identities and Azure Key Vault.
- Conditional Access should require MFA and block legacy authentication for privileged access.
- A dedicated emergency-access account should be excluded from Conditional Access only under a controlled break-glass procedure.
- Privileged Identity Management and access reviews are recommended where Entra licensing is available.

## Validation

Terraform confirmed the identity/RBAC configuration with:

`No changes. Your infrastructure matches the configuration.`

## Scope

NorthStar is portfolio and lab work. Conditional Access, PIM, and access reviews are documented as enterprise controls; they are not represented as active tenant policies unless explicitly deployed and verified.

