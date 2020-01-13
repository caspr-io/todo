# Build NodeJS application
FROM node:12.0-alpine as builder
COPY . /src/todo
WORKDIR /src/todo

RUN npm install
RUN npm run build

# Define image that will serve NodeJS application with Nginx
FROM nginx:latest

# Add application
COPY --from=builder /src/todo/build /var/www/todo

# Add Nginx configuration
ADD nginx-todo.conf /etc/nginx/conf.d/default.conf

# Add script to generate runtime environment
COPY generate-app-config.js.sh /var/www/todo
COPY .env /var/www/todo
RUN chmod +x /var/www/todo/generate-app-config.js.sh
WORKDIR /var/www/todo

# Start Nginx server recreating env-config.js
CMD ["/bin/bash", "-c", "/var/www/todo/generate-app-config.js.sh && nginx -g \"daemon off;\""]
