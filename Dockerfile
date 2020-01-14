# Build NodeJS application
FROM node:12.0-alpine as builder

WORKDIR /src/todo

COPY package-lock.json package.json /src/todo/
RUN npm install

COPY . /src/todo/
RUN npm run build

# Define image that will serve NodeJS application with Nginx
FROM nginx:latest

WORKDIR /var/www/todo

# Add application
COPY --from=builder /src/todo/build /var/www/todo

# Add Nginx configuration
ADD nginx-todo.conf /etc/nginx/conf.d/default.conf

# Add script to generate runtime environment
COPY generate-app-config.js.sh /var/www/todo
COPY .env /var/www/todo
RUN chmod +x /var/www/todo/generate-app-config.js.sh

# Start Nginx server recreating env-config.js
CMD ["/bin/bash", "-c", "./generate-app-config.js.sh > app-config.js && nginx -g \"daemon off;\""]
