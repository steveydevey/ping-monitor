# Network Monitoring Rules and Best Practices

## Overview

This document outlines the monitoring rules, best practices, and guidelines for expanding the network monitoring setup using Prometheus, Grafana, and Blackbox Exporter.

## Current Monitoring Targets

### ICMP (Ping) Monitoring
- **8.8.8.8** - Google DNS (External connectivity test)
- **1.1.1.1** - Cloudflare DNS (External connectivity test)
- **192.168.254.254** - Local network gateway/router
- **192.168.254.9** - Local network device
- **nas.lan** - Network Attached Storage
- **r630.lan** - Dell R630 server

### HTTP Monitoring
- **https://home.jomby.xyz** - Personal website/service
- **https://google.com** - External HTTP connectivity test
- **https://github.com** - External service dependency

### DNS Monitoring
- **nas.lan** - Local DNS resolution
- **r630.lan** - Local DNS resolution
- **home.jomby.xyz** - External DNS resolution

## Metrics Collected

### ICMP Metrics
- `probe_success` - Whether the ping probe succeeded (0 or 1)
- `probe_icmp_duration_seconds` - Round-trip time for ICMP packets
- `probe_icmp_reply_hop_limit` - TTL of reply packets
- `probe_duration_seconds` - Total probe duration

### HTTP Metrics
- `probe_success` - Whether the HTTP probe succeeded (0 or 1)
- `probe_http_duration_seconds` - Total HTTP request duration
- `probe_http_status_code` - HTTP response status code
- `probe_http_content_length` - Size of HTTP response body
- `probe_ssl_earliest_cert_expiry` - SSL certificate expiry timestamp

### DNS Metrics
- `probe_dns_lookup_time_seconds` - DNS resolution time
- `probe_success` - Whether DNS resolution succeeded

## Alerting Rules

### Critical Alerts
1. **HostDown** - Triggers when any monitored host is unreachable for >2 minutes
2. **HTTPServiceDown** - Triggers when HTTP services are down for >1 minute
3. **LocalGatewayDown** - Triggers when local gateway is unreachable for >1 minute
4. **SSLCertificateExpired** - Triggers when SSL certificates have expired

### Warning Alerts
1. **HighPingLatency** - Triggers when ping latency >100ms for >5 minutes
2. **PingPacketLoss** - Triggers when packet loss >5% over 5 minutes
3. **HTTPHighResponseTime** - Triggers when HTTP response time >5s for >3 minutes
4. **HTTPStatusCodeError** - Triggers on HTTP 4xx/5xx status codes for >1 minute
5. **DNSLookupSlow** - Triggers when DNS lookups take >1s for >2 minutes
6. **SSLCertificateExpiringSoon** - Triggers when SSL certificates expire in <30 days

## Best Practices

### Target Selection
1. **External Targets**: Use well-known, reliable external services (Google DNS, Cloudflare DNS)
2. **Internal Infrastructure**: Monitor critical local network components (gateway, NAS, servers)
3. **Service Dependencies**: Monitor external services your applications depend on
4. **Geographical Diversity**: Consider monitoring from multiple locations for comprehensive coverage

### Monitoring Frequency
- **Critical Infrastructure**: 15-30 second intervals
- **External Services**: 30-60 second intervals
- **Internal Services**: 15-30 second intervals
- **Certificate Monitoring**: 1-hour intervals (sufficient for expiry checks)

### Threshold Guidelines
- **Ping Latency**: 
  - Warning: >100ms
  - Critical: >500ms or complete failure
- **HTTP Response Time**:
  - Warning: >5s
  - Critical: >30s or complete failure
- **Packet Loss**:
  - Warning: >5%
  - Critical: >20%
- **DNS Resolution**:
  - Warning: >1s
  - Critical: >5s or complete failure

### Dashboard Organization
1. **Overview Panel**: Current status of all monitored targets
2. **Latency Panels**: Separate panels for ICMP and HTTP latency
3. **Reliability Panels**: Success rate over time
4. **Infrastructure Panels**: Specific panels for local network components
5. **External Services**: Dedicated section for external dependencies

## Expansion Recommendations

### Additional Monitoring Targets
Consider adding these targets based on your infrastructure:

#### Network Infrastructure
- Router/Switch management interfaces
- WiFi access points
- Network printers
- IoT devices
- Security cameras

#### Services
- Database servers (ping + port checks)
- Web servers
- Mail servers
- File servers
- Backup systems

#### External Dependencies
- CDN endpoints
- API services
- Third-party integrations
- Cloud services

### Advanced Monitoring Modules

#### TCP Port Monitoring
```yaml
tcp_connect:
  prober: tcp
  timeout: 5s
  tcp:
    preferred_ip_protocol: "ip4"
```

#### SMTP Monitoring
```yaml
smtp_starttls:
  prober: tcp
  timeout: 5s
  tcp:
    query_response:
      - expect: "^220.*"
      - send: "EHLO prober"
      - expect: "^250-STARTTLS"
      - send: "STARTTLS"
      - expect: "^220"
      - starttls: true
      - send: "EHLO prober"
      - expect: "^250-AUTH"
      - send: "QUIT"
```

#### SNMP Monitoring
Consider adding SNMP exporter for detailed network device metrics:
- Interface statistics
- CPU/Memory usage
- Temperature monitoring
- Error counters

## Security Considerations

1. **Network Exposure**: Ensure monitoring doesn't expose internal network topology
2. **Authentication**: Use proper authentication for Grafana access
3. **Encryption**: Enable HTTPS for Grafana dashboard access
4. **Firewall Rules**: Properly configure firewall rules for monitoring traffic
5. **Credential Management**: Store sensitive credentials securely

## Maintenance Tasks

### Regular Reviews
- **Monthly**: Review alert thresholds and adjust based on performance
- **Quarterly**: Evaluate new targets for monitoring
- **Annually**: Review and update security configurations

### Capacity Planning
- Monitor Prometheus storage usage
- Plan for metric retention periods
- Consider federation for large deployments

### Backup and Recovery
- Backup Grafana dashboards and configurations
- Document recovery procedures
- Test backup restoration regularly

## Troubleshooting Guide

### Common Issues
1. **Blackbox Exporter Not Responding**: Check container logs and network connectivity
2. **Targets Not Resolving**: Verify DNS configuration and network routing
3. **High False Positive Alerts**: Adjust alert thresholds and evaluation periods
4. **Missing Metrics**: Check Prometheus scrape configuration and target reachability

### Debugging Commands
```bash
# Check blackbox exporter status
curl http://localhost:9115/probe?target=8.8.8.8&module=icmp

# Check prometheus targets
curl http://localhost:9090/api/v1/targets

# Check prometheus rules
curl http://localhost:9090/api/v1/rules
```

## Performance Optimization

### Query Optimization
- Use recording rules for frequently accessed metrics
- Implement proper label usage for efficient queries
- Consider metric retention policies

### Resource Management
- Monitor Prometheus memory usage
- Optimize scrape intervals based on requirements
- Use appropriate storage retention periods

### Scaling Considerations
- Plan for horizontal scaling with Prometheus federation
- Consider using Thanos for long-term storage
- Implement proper load balancing for high-availability setups