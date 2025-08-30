#!/bin/bash

# Configuration Validation Script
# Validates Prometheus and Blackbox Exporter configurations

set -e

echo "🔍 Validating monitoring configuration..."

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validate Prometheus configuration
echo "📊 Validating Prometheus configuration..."
if command_exists promtool; then
    promtool check config prometheus.yml
    promtool check rules prometheus-rules.yml prometheus-recording-rules.yml
    echo "✅ Prometheus configuration is valid"
else
    echo "⚠️  promtool not found - skipping Prometheus validation"
    echo "   Install Prometheus tools to enable configuration validation"
fi

# Validate Blackbox configuration syntax
echo "🔍 Validating Blackbox Exporter configuration..."
if command_exists docker; then
    # Use Docker to validate blackbox configuration
    docker run --rm -v "$(pwd)/blackbox.yml:/tmp/blackbox.yml" prom/blackbox-exporter:latest \
        --config.file=/tmp/blackbox.yml --config.check
    echo "✅ Blackbox Exporter configuration is valid"
else
    echo "⚠️  Docker not found - skipping Blackbox validation"
fi

# Check if all target hosts are resolvable
echo "🌐 Checking target host resolution..."
targets=("8.8.8.8" "1.1.1.1" "192.168.254.254" "192.168.254.9" "nas.lan" "r630.lan" "google.com" "github.com")

for target in "${targets[@]}"; do
    # Extract hostname from URL if needed
    hostname=$(echo "$target" | sed 's|https\?://||' | sed 's|/.*||')
    
    if nslookup "$hostname" > /dev/null 2>&1 || ping -c 1 -W 2 "$hostname" > /dev/null 2>&1; then
        echo "✅ $hostname is resolvable"
    else
        echo "⚠️  $hostname is not resolvable - check DNS or network connectivity"
    fi
done

# Check for common configuration issues
echo "🔧 Checking for common configuration issues..."

# Check if rule files are properly referenced
if grep -q "prometheus-rules.yml" prometheus.yml && grep -q "prometheus-recording-rules.yml" prometheus.yml; then
    echo "✅ Rule files are properly referenced"
else
    echo "❌ Rule files are not properly referenced in prometheus.yml"
fi

# Check if blackbox modules are properly configured
if grep -q "icmp:" blackbox.yml && grep -q "http_2xx:" blackbox.yml; then
    echo "✅ Blackbox modules are configured"
else
    echo "❌ Blackbox modules are not properly configured"
fi

# Check docker-compose volume mounts
if grep -q "blackbox.yml:/etc/blackbox_exporter/config.yml" docker-compose.yml; then
    echo "✅ Blackbox configuration is mounted in docker-compose"
else
    echo "❌ Blackbox configuration is not mounted in docker-compose.yml"
fi

echo ""
echo "🎯 Configuration validation complete!"
echo "   Run './setup-monitoring.sh' to start the monitoring stack"