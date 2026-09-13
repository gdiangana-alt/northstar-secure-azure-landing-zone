# NorthStar Cost Control and Teardown Runbook

## Objective

Operate the NorthStar environment with cost awareness while preserving a controlled, Terraform-managed decommissioning path.

## Primary Cost Drivers

| Component | Cost behavior | Operational control |
|---|---|---|
| Application Gateway WAF_v2 | Persistent hourly platform cost and capacity-related usage | Keep the gateway deployed only while demonstrating the portfolio environment |
| Linux App Service B1 | Persistent App Service plan cost | Use one small Linux plan and no scale-out instances |
| Log Analytics and Sentinel | Data-ingestion and retention dependent | Collect only required diagnostic categories and review ingestion regularly |
| Azure Key Vault | Low transaction and storage cost | Store only required certificate material; no application secrets are committed to source control |
| Public IP | Associated with the Application Gateway public entry point | Remove with the gateway during controlled teardown |

## Implemented Cost Controls

- Standard NorthStar tags identify project, environment, owner, and cost-control context.
- Terraform provides a reviewed plan before infrastructure changes.
- The web workload uses a managed App Service backend rather than quota-constrained virtual machines.
- Default outbound access is disabled on all landing-zone subnets.
- Application Gateway logs are routed to the existing SOC workspace rather than creating a duplicate monitoring platform.

## Operational Review

Review Azure Cost Management regularly while the public endpoint is active. The Application Gateway WAF_v2 and App Service plan should be treated as the primary resources to assess when reducing ongoing spend.

Before making changes, run `terraform plan` and confirm that the expected resources and state are current.

## Controlled Teardown

NorthStar must be decommissioned through reviewed Terraform changes, not ad hoc portal deletion.

Before teardown:

1. Preserve validation evidence and confirm the current Git commit is pushed.
2. Run a destroy plan and review every proposed deletion.
3. Confirm whether the subscription diagnostic setting and Sentinel analytics rules should remain. They are Terraform-managed controls, while the SOC workspace itself is referenced as an existing resource.
4. Remove the public web-front components only through approved Terraform changes.
5. Remember that Key Vault soft delete retains the vault name during its retention period.

## Certificate Lifecycle

The current Let’s Encrypt certificate expires on December 12, 2026. Renewal requires DNS validation, import of a new PFX certificate version into Key Vault, and post-renewal HTTPS validation.

## Scope

This runbook is for the NorthStar portfolio environment. Teardown requires an intentional review because it affects monitoring and security controls as well as cost-bearing resources.
