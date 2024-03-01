# Stage 1: Build the Node.js application
FROM node:14 AS build

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the remaining application code to the working directory
COPY . .

# Build the Node.js application
RUN npm run build

# Stage 2: Create a production image with Nginx
FROM nginx:alpine

# Copy the built Node.js application from the previous stage
COPY --from=build /usr/src/app/build /usr/share/nginx/html

# Copy the nginx configuration file
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 to the outside world
EXPOSE 80

# Command to start Nginx
CMD ["nginx", "-g", "daemon off;"]
