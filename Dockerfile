# Use a minimal Node.js base image for smaller attack surface
FROM node:16-slim

# Set working directory inside the container
WORKDIR /app

# Copy only dependency files first to leverage Docker cache
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Create a non-root user to run the app securely
RUN adduser --disabled-password appuser
USER appuser

# Add a health check to let Docker know if your app is alive
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s \
  CMD curl --fail http://localhost:3000/health || exit 1

# Expose the port your app uses
EXPOSE 3000

# Start the Node.js app
CMD ["npm", "start"]
