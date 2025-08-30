# Useful Prometheus Queries and Examples

## Basic Queries

### Connectivity Checks
```promql
# Check if all targets are reachable
probe_success

# Show only failed probes
probe_success == 0

# Count successful probes per job
count by (job) (probe_success == 1)

# Calculate success rate over time
rate(probe_success[5m])
```

### Latency Analysis
```promql
# Current ping latency in milliseconds
probe_icmp_duration_seconds * 1000

# Average latency over 5 minutes
avg_over_time(probe_icmp_duration_seconds[5m]) * 1000

# 95th percentile latency
histogram_quantile(0.95, rate(probe_icmp_duration_seconds_bucket[5m])) * 1000

# Maximum latency in last hour
max_over_time(probe_icmp_duration_seconds[1h]) * 1000
```

### HTTP Monitoring
```promql
# HTTP response times
probe_http_duration_seconds

# HTTP status codes
probe_http_status_code

# SSL certificate expiry (days remaining)
(probe_ssl_earliest_cert_expiry - time()) / 86400

# HTTP content length changes
delta(probe_http_content_length[1h])
```

## Advanced Queries

### Network Reliability Calculations
```promql
# Uptime percentage over last 24 hours
avg_over_time(probe_success[24h]) * 100

# Downtime in minutes over last 24 hours
(1 - avg_over_time(probe_success[24h])) * 24 * 60

# SLA compliance (99.9% target)
avg_over_time(probe_success[30d]) >= 0.999
```

### Comparative Analysis
```promql
# Compare latency between targets
probe_icmp_duration_seconds{instance="8.8.8.8"} / probe_icmp_duration_seconds{instance="1.1.1.1"}

# Show worst performing targets
topk(3, avg_over_time(probe_icmp_duration_seconds[1h]))

# Show most reliable targets
topk(5, avg_over_time(probe_success[24h]))
```

### Alerting Queries
```promql
# High latency alert
probe_icmp_duration_seconds > 0.1

# Packet loss detection
rate(probe_success[5m]) < 0.95

# HTTP error detection
probe_http_status_code >= 400

# Certificate expiry warning (30 days)
probe_ssl_earliest_cert_expiry - time() < 30 * 24 * 3600
```

## Dashboard Query Examples

### Single Stat Panels
```promql
# Current overall network health
avg(probe_success)

# Total monitored targets
count(probe_success)

# Average ping latency
avg(probe_icmp_duration_seconds) * 1000
```

### Time Series Panels
```promql
# Success rate by target
probe_success

# Latency trends
probe_icmp_duration_seconds * 1000

# HTTP response time trends
probe_http_duration_seconds * 1000
```

### Table Panels
```promql
# Target status summary
probe_success

# Latest latency by target
probe_icmp_duration_seconds * 1000

# HTTP status code summary
probe_http_status_code
```

## Recording Rules

### Performance Optimization
```yaml
# Pre-calculated 5-minute success rates
- record: ping:success_rate_5m
  expr: avg_over_time(probe_success{job="blackbox"}[5m])

# Pre-calculated average latency
- record: ping:avg_latency_5m
  expr: avg_over_time(probe_icmp_duration_seconds{job="blackbox"}[5m])

# Pre-calculated HTTP success rates
- record: http:success_rate_5m
  expr: avg_over_time(probe_success{job="blackbox_http"}[5m])
```

## Custom Metrics

### Business Logic Metrics
```promql
# Network reliability score (weighted by importance)
(
  probe_success{instance="8.8.8.8"} * 0.2 +
  probe_success{instance="192.168.254.254"} * 0.3 +
  probe_success{instance="nas.lan"} * 0.25 +
  probe_success{instance="r630.lan"} * 0.25
)

# Local network health (excluding external targets)
avg(probe_success{instance=~"192\\.168\\..*|.*\\.lan"})

# External connectivity health
avg(probe_success{instance=~"8\\.8\\.8\\.8|1\\.1\\.1\\.1|.*\\.com|.*\\.xyz"})
```

## Grafana Variables

### Dynamic Target Selection
```
# Variable: target
Query: label_values(probe_success, instance)
Regex: /.*/
Multi-value: true
Include All: true
```

### Job Filtering
```
# Variable: job
Query: label_values(probe_success, job)
Multi-value: true
Include All: true
```

## Troubleshooting Queries

### Diagnostic Queries
```promql
# Show all metrics for a specific target
{instance="nas.lan"}

# Check scrape success
up{job="blackbox"}

# Show probe configuration
probe_config_hash

# DNS resolution issues
probe_dns_lookup_time_seconds > 1
```

### Performance Analysis
```promql
# Identify slowest targets
bottomk(5, avg_over_time(probe_icmp_duration_seconds[1h]))

# Find most unreliable targets
bottomk(5, avg_over_time(probe_success[24h]))

# Detect intermittent issues
stddev_over_time(probe_success[1h]) > 0.1
```

## Integration Examples

### Webhook Alerts
```yaml
# Example webhook configuration for Alertmanager
route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'web.hook'
receivers:
- name: 'web.hook'
  webhook_configs:
  - url: 'http://localhost:5001/'
```

### Slack Notifications
```yaml
# Slack notification configuration
receivers:
- name: 'slack-notifications'
  slack_configs:
  - api_url: 'YOUR_SLACK_WEBHOOK_URL'
    channel: '#alerts'
    title: 'Network Alert'
    text: 'Alert: {{ .GroupLabels.alertname }} - {{ .CommonAnnotations.summary }}'
```