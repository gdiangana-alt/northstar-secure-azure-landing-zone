# Application Gateway WAF Log Validation

## Objective

Validate that Application Gateway WAF telemetry reaches the NorthStar SOC Log Analytics workspace.

## Validation Activity

A controlled HTTP request was sent to the Application Gateway public IP address during lab validation.

The request returned HTTP 200 because the WAF policy is operating in Detection mode.

## Observed WAF Event

Log Analytics recorded an `ApplicationGatewayFirewallLog` event for the NorthStar Application Gateway.

| Field | Observed value |
|---|---|
| WAF action | `Matched` |
| OWASP rule ID | `920350` |
| Rule group | `REQUEST-920-PROTOCOL-ENFORCEMENT` |
| Rule set | OWASP CRS 3.2 |
| Request URI | `/` |
| Message | Host header is a numeric IP address |
| WAF policy | `northstar-lz-waf-policy` |

The match was caused by using the gateway public IP address as the HTTP Host header during controlled validation.

## Result

This confirms that Application Gateway WAF logs are collected by Log Analytics and can support Sentinel investigation and alerting.

The WAF remains in Detection mode while rules are observed and tuned. A production change to Prevention mode would require a reviewed false-positive and rollback process.

## Scope

This is controlled portfolio-lab validation, not evidence of malicious activity.
