# # Simple Dockerfile for React App(772MB)
# FROM node:18-slim
# # Set working directory
# WORKDIR /app
# # Copy package.json and package-lock.json
# COPY package*.json ./
# # Install dependencies
# RUN npm install --only=production
# # Copy the rest of the application
# COPY . .
# # Expose port 3000
# EXPOSE 3000
# # Command to start the application
# CMD ["npm", "start"]


# Dockerfile for React App with Multi-Stage Build (140MB)
# Build Stage
# FROM node:18-slim AS build
# # Set working directory
# WORKDIR /app
# # Copy package.json and package-lock.json
# COPY package*.json ./
# # Install dependencies
# RUN npm install --only=production
# # Copy the rest of the application
# COPY . .
# # Build the application
# RUN npm run build
# # Production Stage
# FROM node:18-alpine AS production
# # Set working directory
# WORKDIR /app
# # Install serve to serve the production build
# RUN npm install -g serve
# # Copy built application from build stage
# COPY --from=build /app/build ./build
# # Expose port 3000
# EXPOSE 3000
# # Command to start the application
# CMD ["serve", "-s", "build", "-l", "3000"]


# Dockerfile for React App with Multi-Stage Build and Nginx(50MB)
# Build Stage
FROM node:18-slim AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install --only=production

# Copy the rest of the application
COPY . .

# Build the application
RUN npm run build

# Production Stage
FROM nginx:alpine AS production

# Set working directory to Nginx web root
WORKDIR /usr/share/nginx/html

# Remove default Nginx static files
RUN rm -rf ./*

# Copy built application from build stage
COPY --from=build /app/build ./

# Expose port 80
EXPOSE 80

# Use Nginx as the entry point
ENTRYPOINT ["nginx", "-g", "daemon off;"]
