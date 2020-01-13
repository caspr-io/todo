FROM node:12.0-alpine as builder
COPY . /src/todo
WORKDIR /src/todo

RUN npm install
RUN npm run build

# ------ END BUILD STAGE ------

FROM nginx:latest


# Add application
COPY --from=builder /src/todo/build /var/www/todo

# Add NGINX configuration
ADD nginx-todo.conf /etc/nginx/conf.d/default.conf

# Add script to generate runtime environment
COPY env.sh /var/www/todo
COPY .env /var/www/todo
RUN chmod +x /var/www/todo/env.sh
WORKDIR /var/www/todo

# Start Nginx server recreating env-config.js
CMD ["/bin/bash", "-c", "/var/www/todo/env.sh && nginx -g \"daemon off;\""]
