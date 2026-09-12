# NorthStar Web Front End and WAF Architecture

## Objective

Add a secure public-entry design for the NorthStar environment while preserving segmentation, least privilege, monitoring, and cost control.

## Current Deployment Status

- The dedicated `waf` subnet is deployed in `northstar-lz-vnet`.
- WAF subnet address range: `10.20.10.0/24`.
- Default outbound access is disabled.
- No Network Security Group is attached to the WAF subnet, as Application Gateway requires a dedicated subnet.
- Application Gateway WAF, a web workload, Key Vault integration, and a public endpoint are planned but not yet deployed.

## Target Architecture

```mermaid
flowchart TB
    internet["Internet users"] --> waf["Application Gateway WAF"]
    waf --> web["Private web tier"]
    web --> app["Private application tier"]
    waf --> soc["Log Analytics and Microsoft Sentinel"]
