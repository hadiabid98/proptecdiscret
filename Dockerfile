# Build Stage
FROM node:20-slim AS build

WORKDIR /app

# Copy package files (legacy-peer-deps handled in .npmrc)
COPY package.json package-lock.json* .npmrc* ./

# Install dependencies
RUN npm ci --legacy-peer-deps || npm install --legacy-peer-deps

# Copy the rest of the source code
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

# Add custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
