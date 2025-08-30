# Ping Monitoring Dashboard 📊

My ISP didn't believe me that my internet connection was unreliable, so I created this dashboard using **Docker, Grafana, and Prometheus** to monitor my connection and provide hard data.

## Overview

The dashboard is designed to help monitor the network reliability and latency of ping requests using Prometheus and Grafana. It includes multiple metrics that provide insight into ping response times, success rates, and additional diagnostic data. 

## Screenshots

Two example screenshots are included to illustrate the behavior of the dashboard under different network conditions:

### Good Scenario

The `good.png` screenshot (located in `screenshots/good.png`) represents a situation where the network is stable, with high reliability and low ICMP duration. Most ping probes succeed, with consistent round-trip times.

![Good Scenario](screenshots/good.png)

### Bad Scenario (real example 😬)

The `bad.png` screenshot (located in `screenshots/bad.png`) shows a situation where there are network issues, resulting in lower reliability and fluctuating ICMP duration. Some ping probes fail, and response times vary greatly.

![Bad Scenario](screenshots/bad.png)

### Key Metrics

- **Reliability**: Displays the overall success rate of the ping probes, showing how reliable the network is over a period.
- **Probe Success**: Indicates whether the ping probes successfully reached the target server.
- **ICMP Duration Seconds**: The round-trip time (RTT) in milliseconds for ICMP ping packets.
- **DNS Lookup Time**: Time spent on DNS lookups, which is measured in microseconds.
- **Probe Duration Seconds**: The total time it takes for the ping probe to complete.
- **Reply Hop Limit**: Displays the time-to-live (TTL) of the ping reply packets, indicating how many hops the packet took.

## Getting Started

### Quick Start
1. Ensure you have Docker installed and running on your system.
2. Run the setup script: `./setup-monitoring.sh`
3. Access the dashboards:
   - **Original Dashboard**: [http://localhost:3000/d/cdwor2stprugwd/ping](http://localhost:3000/d/cdwor2stprugwd/ping)
   - **Enhanced Dashboard**: [http://localhost:3000/d/enhanced-monitoring/enhanced-network-monitoring](http://localhost:3000/d/enhanced-monitoring/enhanced-network-monitoring)

### Manual Setup
1. Validate configuration: `./validate-config.sh`
2. Start services: `docker-compose up -d`
3. Stop services: `docker-compose down`
4. Clean up volumes: `docker-compose down -v`

## Enhanced Features

### Monitoring Targets
- **ICMP (Ping)**: 8.8.8.8, 1.1.1.1, 192.168.254.254, 192.168.254.9, nas.lan, r630.lan
- **HTTP**: https://home.jomby.xyz, https://google.com, https://github.com
- **DNS**: nas.lan, r630.lan, home.jomby.xyz
- **SSL Certificates**: HTTPS endpoints with expiry monitoring
- **TCP Ports**: SSH and HTTP ports on local servers

### Alerting Rules
- Network connectivity failures
- High latency warnings
- Packet loss detection
- HTTP service failures
- SSL certificate expiry warnings
- Local infrastructure issues

### Documentation
- **[MONITORING_RULES.md](MONITORING_RULES.md)**: Comprehensive monitoring rules and best practices
- **[EXPANSION_PLAN.md](EXPANSION_PLAN.md)**: Roadmap for future enhancements
- **[QUERIES_AND_EXAMPLES.md](QUERIES_AND_EXAMPLES.md)**: Useful Prometheus queries and examples
- **[IMPROVEMENT_SUGGESTIONS.md](IMPROVEMENT_SUGGESTIONS.md)**: Additional improvement ideas and implementation guidance

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
