# Multi-stage build for React frontend and Node.js backend

# Stage 1: Build the React frontend
FROM node:22-alpine AS frontend-builder

WORKDIR /app/frontend

# Copy frontend package files
COPY package.json yarn.lock ./

# Install frontend dependencies
RUN yarn install --frozen-lockfile

# Copy frontend source code
COPY . .

# Build the frontend
ARG VITE_API_BASE_URL
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}

RUN yarn build

# Stage 2: Build the backend server
FROM node:22-alpine AS backend-builder

WORKDIR /app/backend

# Copy backend package files
COPY server/package.json ./

# Install backend dependencies
RUN npm install --production

# Stage 3: Production image
FROM node:22-alpine

WORKDIR /app

# Install serve to serve the static frontend
RUN npm install -g serve

# Copy backend files
COPY --from=backend-builder /app/backend /app/backend

# Copy frontend build
COPY --from=frontend-builder /app/frontend/dist /app/frontend/dist

# Copy startup script
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh

# Expose ports
# 3000 for frontend, 8080 for backend
EXPOSE 3000 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:8080/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Start both frontend and backend
ENTRYPOINT ["/app/docker-entrypoint.sh"]