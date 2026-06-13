#!/bin/sh
set -e
# Default values if env vars are not set
VITE_GRAPHQL_URI="${VITE_GRAPHQL_URI:-http://100.57.163.24:8082/graphql}"
VITE_SERVER_URI="${VITE_SERVER_URI:-http://100.57.163.24:8082}"

# Replace placeholders in all JS files with actual runtime values
find /usr/share/nginx/html/assets -name '*.js' -exec sed -i "s|VITE_GRAPHQL_URI_PLACEHOLDER|${VITE_GRAPHQL_URI}|g" {} +
find /usr/share/nginx/html/assets -name '*.js' -exec sed -i "s|VITE_SERVER_URI_PLACEHOLDER|${VITE_SERVER_URI}|g" {} +

echo "Configured VITE_GRAPHQL_URI=${VITE_GRAPHQL_URI}"
echo "Configured VITE_SERVER_URI=${VITE_SERVER_URI}"

exec nginx -g 'daemon off;'