# Build Stage
FROM node:22-alpine AS build

WORKDIR /app

# Copy package files from frontend directory
COPY package.json package-lock.json* .npmrc* ./

# Install dependencies (using legacy-peer-deps)
RUN npm ci --legacy-peer-deps || npm install --legacy-peer-deps

# Copy the rest of the frontend source code (contents only)
COPY . .

# Production optimizations
ENV DISABLE_ESLINT_PLUGIN=true
ENV GENERATE_SOURCEMAP=false
ENV CI=false

# Build the React application
RUN npm run build

# Production Stage: Serve with Nginx
FROM nginx:stable-alpine

# Copy built files from build stage to nginx html folder
COPY --from=build /app/build /usr/share/nginx/html

# Add custom nginx config (already in the current directory /app)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
