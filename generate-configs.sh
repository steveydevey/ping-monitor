#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Set defaults if not provided
PROMETHEUS_INTERNAL_PORT=${PROMETHEUS_INTERNAL_PORT:-9090}
GRAFANA_INTERNAL_PORT=${GRAFANA_INTERNAL_PORT:-3000}

echo "Generating configuration files with:"
echo "  PROMETHEUS_INTERNAL_PORT: $PROMETHEUS_INTERNAL_PORT"
echo "  GRAFANA_INTERNAL_PORT: $GRAFANA_INTERNAL_PORT"

# Generate datasource configuration
sed "s/\${PROMETHEUS_INTERNAL_PORT:-9090}/$PROMETHEUS_INTERNAL_PORT/g" grafana/provisioning/datasources/datasource.yml.template > grafana/provisioning/datasources/datasource.yml

echo "Configuration files generated successfully!"