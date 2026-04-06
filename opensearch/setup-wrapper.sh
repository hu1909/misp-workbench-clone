#!/bin/bash
set -e

SETUP_DIR="/usr/share/opensearch/setup"

# Start OpenSearch in the background
echo "Starting OpenSearch..."
/usr/share/opensearch/opensearch-docker-entrypoint.sh &
OPENSEARCH_PID=$!

# Wait for OpenSearch to be ready
OPENSEARCH_URL="https://localhost:9200"
MAX_RETRIES=30
RETRY_COUNT=0

echo "Waiting for OpenSearch to be ready at ${OPENSEARCH_URL}..."

until curl -s -k --user admin:${OPENSEARCH_INITIAL_ADMIN_PASSWORD} "${OPENSEARCH_URL}/_cluster/health" >/dev/null 2>&1; do
  RETRY_COUNT=$((RETRY_COUNT+1))
  if [ "$RETRY_COUNT" -ge "$MAX_RETRIES" ]; then
    echo "ERROR: OpenSearch is not ready after $MAX_RETRIES attempts."
    exit 1
  fi
  echo "OpenSearch is not ready yet. Retrying in 3 seconds... ($RETRY_COUNT/$MAX_RETRIES)"
  sleep 3
done

echo "OpenSearch is ready! Starting setup..."

# Create ingest pipelines
echo "Creating ingest pipelines..."
for file in "${SETUP_DIR}/pipelines"/*.json; do
  [ -e "$file" ] || continue
  PIPELINE_NAME=$(basename "$file" .json)
  
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" -k --user admin:${OPENSEARCH_INITIAL_ADMIN_PASSWORD} \
    "${OPENSEARCH_URL}/_ingest/pipeline/${PIPELINE_NAME}")
  
  if [ "$STATUS" -eq 200 ]; then
    echo "  Pipeline '$PIPELINE_NAME' already exists"
  else
    echo "  Creating pipeline '$PIPELINE_NAME'..."
    curl -s -k -X PUT "${OPENSEARCH_URL}/_ingest/pipeline/${PIPELINE_NAME}" \
      -H "Content-Type: application/json" \
      --user admin:${OPENSEARCH_INITIAL_ADMIN_PASSWORD} \
      -d @"$file" >/dev/null
  fi
done

# Create index templates
echo "Creating index templates..."
for file in "${SETUP_DIR}/index-templates"/*.json; do
  [ -e "$file" ] || continue
  TEMPLATE_NAME=$(basename "$file" .json)
  
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" -k --user admin:${OPENSEARCH_INITIAL_ADMIN_PASSWORD} \
    "${OPENSEARCH_URL}/_index_template/${TEMPLATE_NAME}")
  
  if [ "$STATUS" -eq 200 ]; then
    echo "  Template '$TEMPLATE_NAME' already exists"
  else
    echo "  Creating template '$TEMPLATE_NAME'..."
    curl -s -k -X PUT "${OPENSEARCH_URL}/_index_template/${TEMPLATE_NAME}" \
      -H "Content-Type: application/json" \
      --user admin:${OPENSEARCH_INITIAL_ADMIN_PASSWORD} \
      -d @"$file" >/dev/null
  fi
done

# Create indices
echo "Creating indices..."
for file in "${SETUP_DIR}/mappings"/*.json; do
  [ -e "$file" ] || continue
  INDEX_NAME=$(basename "$file" .json)
  
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" -k --user admin:${OPENSEARCH_INITIAL_ADMIN_PASSWORD} \
    "${OPENSEARCH_URL}/${INDEX_NAME}")
  
  if [ "$STATUS" -eq 200 ]; then
    echo "  Index '$INDEX_NAME' already exists"
  else
    echo "  Creating index '$INDEX_NAME'..."
    curl -s -k -X PUT "${OPENSEARCH_URL}/${INDEX_NAME}" \
      -H "Content-Type: application/json" \
      --user admin:${OPENSEARCH_INITIAL_ADMIN_PASSWORD} \
      -d @"$file" >/dev/null
  fi
done

# Configure dashboards_system user
echo "Configuring dashboards_system user..."
curl -s -k -u admin:${OPENSEARCH_INITIAL_ADMIN_PASSWORD} \
  -X PUT "${OPENSEARCH_URL}/_plugins/_security/api/internalusers/dashboards_system" \
  -H "Content-Type: application/json" \
  -d "{
    \"password\": \"${OPENSEARCH_DASHBOARDS_PASSWORD}\",
    \"backend_roles\": [\"dashboards_system\"],
    \"description\": \"OpenSearch Dashboards service user\"
  }" >/dev/null 2>&1 || true

echo "✓ OpenSearch setup completed successfully!"
echo "OpenSearch is running and ready to accept connections."

# Keep OpenSearch running in foreground
wait $OPENSEARCH_PID
