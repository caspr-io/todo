# Build NodeJS application
FROM node:12.0-alpine as builder

WORKDIR /src/todo

COPY package-lock.json package.json /src/todo/
RUN npm install

COPY . /src/todo/
RUN npm run build

# Define image that will serve NodeJS application with Nginx
FROM nginx:1.17.8-alpine

WORKDIR /var/www/todo

# Add application
COPY --from=builder /src/todo/build /var/www/todo

# Add Nginx configuration
ADD nginx-todo.conf /etc/nginx/conf.d/default.conf

# Add script to generate runtime environment
COPY generate-app-config.js.sh /var/www/todo
COPY .env /var/www/todo
RUN chmod +x /var/www/todo/generate-app-config.js.sh

# Install helm and the helm push plugin
ENV HELM_VERSION=3.1.1
ENV HELM_BASE_URL="https://get.helm.sh"
ENV HELM_TAR_FILE="helm-v${HELM_VERSION}-linux-amd64.tar.gz"
RUN apk add --update --no-cache curl ca-certificates git && \
  curl -L ${HELM_BASE_URL}/${HELM_TAR_FILE} |tar xvz && \
  mv linux-amd64/helm /usr/bin/helm && \
  chmod +x /usr/bin/helm && \
  rm -rf linux-amd64 && \
  apk del curl && \
  helm plugin install https://github.com/chartmuseum/helm-push && \
  rm -f /var/cache/apk/*

# Add Helm chart
COPY helm /helm/

# Start Nginx server recreating env-config.js
CMD ["/bin/bash", "-c", "./generate-app-config.js.sh > app-config.js && nginx -g \"daemon off;\""]
