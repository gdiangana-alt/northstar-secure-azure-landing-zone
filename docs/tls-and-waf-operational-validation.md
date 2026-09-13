# NorthStar TLS and WAF Operational Validation

## Objective

Validate trusted public HTTPS delivery and verify that Application Gateway WAF telemetry creates actionable, appropriately grouped Sentinel incidents.

## Trusted HTTPS Validation

The NorthStar public endpoint is available at:

`https://northstar.guydiangana.com`

A Let’s Encrypt certificate was issued through DNS validation and imported into Azure Key Vault as `northstar-tls`.

| Validation | Result |
|---|---|
| Certificate subject | `CN=northstar.guydiangana.com` |
| Certificate issuer | Let’s Encrypt |
| Certificate validity | September 13, 2026 to December 12, 2026 |
| HTTP behavior | HTTP returns `301 Moved Permanently` to HTTPS |
| HTTPS behavior | HTTPS returns `200 OK` |
| Backend health | Application Gateway reports the App Service backend as healthy |

Application Gateway uses a user-assigned managed identity with the `Key Vault Secrets User` role at the vault scope. The HTTPS listener references the versionless Key Vault secret URI, allowing Application Gateway to retrieve an updated certificate version after renewal.

## WAF and Sentinel Validation

Application Gateway WAF is configured with OWASP Core Rule Set 3.2 in Detection mode. Gateway access, performance, and firewall telemetry is routed to `NorthStar-SOC-Workspace`.

Controlled validation and normal public-web traffic generated WAF matches, including:

- OWASP rule `920350` for a numeric IP address in the HTTP Host header.
- OWASP rule `920300` for common public-web discovery requests.

The scheduled Sentinel rule `NorthStar - Application Gateway WAF Rule Match` generated Low severity alerts and incidents from these WAF matches.

## Detection Tuning Decision

Initial validation showed that one alert and incident were generated per matched WAF event. This was too noisy for effective triage.

The rule was tuned to:

- create a single alert per scheduled query run;
- attach source IP, request URI, WAF rule ID, and WAF rule group as alert context; and
- group related alerts into one Sentinel incident for a one-hour lookback period.

This preserves visibility while reducing incident fatigue.

## Certificate Lifecycle

The current certificate was issued through a manual DNS validation workflow for this portfolio environment. Renewal must occur before expiry and the renewed PFX must be imported as a new Key Vault certificate version.

Application Gateway references the versionless Key Vault secret URI and polls Key Vault for updated certificate versions. The remaining operational improvement is to automate DNS validation and certificate renewal outside Cloud Shell.

## Scope

This is controlled portfolio-lab validation. WAF matches are triaged as expected test traffic or routine internet scanning unless investigation establishes malicious intent.
