# # Simple Dockerfile for React App
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


# Dockerfile for React App with Multi-Stage Build
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
FROM node:18-alpine AS production

# Set working directory
WORKDIR /app

# Install serve to serve the production build
RUN npm install -g serve

# Copy built application from build stage
COPY --from=build /app/build ./build

# Expose port 3000
EXPOSE 3000

# Command to start the application
CMD ["serve", "-s", "build", "-l", "3000"]
