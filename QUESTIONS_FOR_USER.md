# Questions for Further Customization

## Network Infrastructure Questions

### 1. Local Network Topology
- Are there other IP addresses or hostnames in your local network that should be monitored?
- Do you have any network switches, access points, or other infrastructure devices?
- Are there any specific ports or services running on nas.lan and r630.lan that should be monitored?

### 2. External Dependencies
- Besides https://home.jomby.xyz, are there other external services your infrastructure depends on?
- Do you use any cloud services (AWS, Azure, GCP) that should be monitored?
- Are there any APIs or third-party services critical to your operations?

### 3. ISP and Connectivity
- What is your ISP's gateway IP address?
- Do you have multiple internet connections that should be monitored separately?
- Are there specific ISP-provided services (mail servers, DNS) that should be monitored?

## Alerting and Notifications

### 1. Notification Preferences
- How would you like to receive alerts? (Email, Slack, Discord, SMS, etc.)
- What are your preferred notification channels for different severity levels?
- Do you have existing notification systems that should be integrated?

### 2. Alert Timing
- What are your business hours? Should alerting behavior change after hours?
- How quickly do you need to be notified of critical issues?
- Are there maintenance windows when alerts should be suppressed?

### 3. Escalation Policies
- Who should be notified for different types of issues?
- Do you have an on-call rotation or escalation procedure?
- Should certain alerts automatically create tickets in a ticketing system?

## Performance and SLA Requirements

### 1. Service Level Objectives
- What availability targets do you have for different services?
- What are acceptable latency thresholds for your network?
- Do you have specific packet loss tolerances?

### 2. Historical Data
- How long should monitoring data be retained?
- Do you need to generate regular reports or compliance documentation?
- Are there specific metrics that need to be tracked for business purposes?

## Technical Integration

### 1. Existing Tools
- Do you have existing monitoring tools that should be integrated?
- Are you using any configuration management tools (Ansible, Terraform)?
- Do you have existing logging or APM solutions?

### 2. Authentication Systems
- Do you need to integrate with LDAP, Active Directory, or other authentication systems?
- Should Grafana use single sign-on (SSO)?
- Are there specific security requirements or restrictions?

### 3. Deployment Environment
- Is this running on bare metal, VMs, or containers?
- Do you plan to deploy this in Kubernetes or other orchestration platforms?
- Are there specific resource constraints or requirements?

## Business Requirements

### 1. Compliance and Reporting
- Do you have specific compliance requirements (SOC2, ISO 27001, etc.)?
- Are regular uptime reports needed for SLA compliance?
- Do you need to track specific business metrics alongside technical metrics?

### 2. Team Structure
- How many people will be using these dashboards?
- Do different teams need different views or access levels?
- Should there be role-based access control?

### 3. Growth Planning
- How do you expect your infrastructure to grow over the next year?
- Are there plans to add new services or locations?
- Should the monitoring setup be designed for specific scaling patterns?

## Specific Implementation Questions

### 1. Current Pain Points
- What specific network issues have you experienced that led to this monitoring setup?
- Are there particular times of day when issues are more common?
- What manual checks do you currently perform that could be automated?

### 2. Success Criteria
- How will you measure the success of this monitoring implementation?
- What specific problems should this solve?
- What decisions should this data help you make?

### 3. Future Enhancements
- Are you interested in predictive analytics or anomaly detection?
- Would you like to implement chaos engineering or synthetic testing?
- Are there specific integrations with other tools you'd like to see?

## Technical Specifications

### 1. Network Details
- What is the subnet configuration for your local network?
- Are there VLANs or network segments that should be monitored separately?
- Do you use IPv6 that should also be monitored?

### 2. Service Details
- What specific services are running on r630.lan? (web server, database, etc.)
- What type of NAS is nas.lan? (Synology, QNAP, custom build?)
- Are there specific protocols or ports that are critical for these services?

### 3. Security Considerations
- Are there network security tools (firewalls, IDS/IPS) that should be monitored?
- Do you need to monitor VPN connections or remote access?
- Should the monitoring respect any security boundaries or restrictions?

## Response Template

Please review these questions and provide answers for any that are relevant to your setup. You can answer in any format - bullet points, paragraphs, or even just the specific details you'd like to see implemented. This will help me further customize the monitoring setup to your specific needs and environment.

Example response format:
```
Network Infrastructure:
- Additional targets: 192.168.1.1 (router), printer.lan
- r630.lan runs: Docker, Plex, SSH
- nas.lan is: Synology DS920+ with web interface on port 5000

Alerting:
- Prefer Slack notifications to #alerts channel
- Critical alerts should also send email to admin@domain.com
- Business hours: 9 AM - 5 PM EST, suppress non-critical alerts after hours

Additional Services:
- Monitor my blog at https://blog.example.com
- Check API endpoint at https://api.example.com/health
- Monitor VPN connection to office
```