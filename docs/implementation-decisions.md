# NorthStar Implementation Decisions and Lessons Learned

## Purpose

This document records meaningful engineering decisions made while building the NorthStar Secure Azure Landing Zone. It distinguishes deployed controls from documented future-state recommendations.

## Compute Platform Decision

The initial web-tier design used a private Linux virtual machine running Nginx. Terraform validation was successful, but Azure Canada Central repeatedly rejected available VM SKUs because of regional capacity restrictions. One attempted D-series size also had no approved family quota.

Rather than weaken the architecture or repeatedly retry unavailable compute, the web tier was redesigned as a Linux Azure App Service running Nginx.

The deployed path is:

Public IP → Application Gateway WAF → HTTPS App Service backend

This retains a protected application-delivery architecture while using a managed, cloud-native backend.

## Web Security Controls

- Application Gateway uses a WAF_v2 SKU and the NorthStar OWASP 3.2 WAF policy.
- The WAF policy begins in Detection mode so traffic can be observed before enforcement rules are tuned.
- The public gateway routes to the App Service over HTTPS.
- The App Service is HTTPS-only.
- App Service access restrictions deny all direct traffic except traffic originating from the dedicated WAF subnet.
- FTP and Web Deploy basic authentication are disabled.
- Application Gateway access, performance, and WAF logs are sent to the SOC Log Analytics workspace.

## Identity and Secrets Design

- The App Service has a system-assigned managed identity.
- Azure Key Vault uses Azure RBAC authorization and denies public data-plane access by default.
- The App Service identity has only the `Key Vault Secrets User` role at the vault scope.
- No secret values are committed to Terraform source code or GitHub.

## Terraform and Operational Resilience

- Existing Azure resources were imported into Terraform state before being managed as code.
- Terraform state was moved from local storage to an Azure Storage remote backend with state locking.
- GitHub is the durable source-of-truth for Terraform code.
- Each material change was validated with `terraform fmt`, `terraform validate`, a reviewed plan, and a post-change drift check.
- Cloud Shell session instability reinforced the value of remote state and frequent Git commits.

## Current Limitation

The public Application Gateway listener currently uses HTTP for lab validation. The gateway-to-App-Service backend connection uses HTTPS.

A trusted public HTTPS listener requires a verified custom domain and certificate. The intended production pattern is a certificate stored in Azure Key Vault and retrieved by Application Gateway through managed identity.

## Scope

NorthStar is portfolio and lab work, not employer production experience.
