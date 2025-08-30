#!/bin/bash

# Enhanced Network Monitoring Setup Script
# This script sets up and validates the expanded monitoring configuration

set -e

echo "🚀 Setting up Enhanced Network Monitoring..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose > /dev/null 2>&1; then
    echo "❌ docker-compose is not installed. Please install docker-compose and try again."
    exit 1
fi

echo "✅ Docker environment validated"

# Validate configuration files
echo "🔍 Validating configuration files..."

# Check if all required files exist
required_files=("prometheus.yml" "blackbox.yml" "prometheus-rules.yml" "prometheus-recording-rules.yml" "docker-compose.yml")
for file in "${required_files[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo "❌ Required file $file not found"
        exit 1
    fi
done

echo "✅ All configuration files found"

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose down -v

# Start the monitoring stack
echo "🚀 Starting monitoring stack..."
docker-compose up -d

# Wait for services to start
echo "⏳ Waiting for services to start..."
sleep 30

# Validate services
echo "🔍 Validating services..."

# Check Prometheus
if curl -s http://localhost:9090/-/healthy > /dev/null; then
    echo "✅ Prometheus is healthy"
else
    echo "❌ Prometheus health check failed"
    exit 1
fi

# Check Blackbox Exporter
if curl -s http://localhost:9115/ > /dev/null; then
    echo "✅ Blackbox Exporter is responding"
else
    echo "❌ Blackbox Exporter health check failed"
    exit 1
fi

# Check Grafana
if curl -s http://localhost:3000/api/health > /dev/null; then
    echo "✅ Grafana is healthy"
else
    echo "❌ Grafana health check failed"
    exit 1
fi

# Test some basic probes
echo "🧪 Testing monitoring probes..."

# Test ICMP probe
if curl -s "http://localhost:9115/probe?target=8.8.8.8&module=icmp" | grep -q "probe_success 1"; then
    echo "✅ ICMP probe test successful"
else
    echo "⚠️  ICMP probe test failed - check network connectivity"
fi

# Test HTTP probe
if curl -s "http://localhost:9115/probe?target=https://google.com&module=http_2xx" | grep -q "probe_success 1"; then
    echo "✅ HTTP probe test successful"
else
    echo "⚠️  HTTP probe test failed - check internet connectivity"
fi

# Check Prometheus targets
echo "📊 Checking Prometheus targets..."
if curl -s http://localhost:9090/api/v1/targets | grep -q "blackbox"; then
    echo "✅ Prometheus is scraping blackbox targets"
else
    echo "❌ Prometheus targets not configured correctly"
    exit 1
fi

echo ""
echo "🎉 Enhanced Network Monitoring setup complete!"
echo ""
echo "📊 Access your dashboards:"
echo "   • Grafana: http://localhost:3000"
echo "   • Original Dashboard: http://localhost:3000/d/cdwor2stprugwd/ping"
echo "   • Enhanced Dashboard: http://localhost:3000/d/enhanced-monitoring/enhanced-network-monitoring"
echo "   • Prometheus: http://localhost:9090"
echo "   • Blackbox Exporter: http://localhost:9115"
echo ""
echo "🔧 Monitoring Targets:"
echo "   • ICMP: 8.8.8.8, 1.1.1.1, 192.168.254.254, 192.168.254.9, nas.lan, r630.lan"
echo "   • HTTP: https://home.jomby.xyz, https://google.com, https://github.com"
echo "   • DNS: nas.lan, r630.lan, home.jomby.xyz"
echo "   • SSL: https://home.jomby.xyz, https://github.com, https://google.com"
echo "   • TCP: r630.lan:22/80, nas.lan:22/80/443"
echo ""
echo "📚 Documentation:"
echo "   • Monitoring Rules: MONITORING_RULES.md"
echo "   • Expansion Plan: EXPANSION_PLAN.md"
echo "   • Query Examples: QUERIES_AND_EXAMPLES.md"
echo ""
echo "🚨 Default Grafana credentials: admin/admin"
echo "   (Anonymous access is enabled for this demo)"