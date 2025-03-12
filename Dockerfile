# Stage 1: Build the SvelteKit app
FROM node:18 AS builder

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the app
COPY . .

# Build the app
RUN npm run build

# Stage 2: Serve the built app
FROM node:18

WORKDIR /app

# Copy built files from the builder stage
COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules

# Expose the port
EXPOSE 3000

# Start the app
CMD ["node", "build"]
