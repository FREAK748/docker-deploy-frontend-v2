FROM node:22-alpine AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps
COPY . .

# Build with placeholder values that will be replaced at runtime
RUN VITE_GRAPHQL_URI=VITE_GRAPHQL_URI_PLACEHOLDER \
    VITE_SERVER_URI=VITE_SERVER_URI_PLACEHOLDER \
    npm run build

# Production stage
FROM nginx:alpine AS production-stage
COPY nginx-custom.conf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Script that replaces placeholders with runtime env vars, then starts nginx
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
EXPOSE 8080
ENTRYPOINT ["/docker-entrypoint.sh"]