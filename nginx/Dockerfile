FROM nginx:alpine

# Install apache2-utils for htpasswd
RUN apk add --no-cache apache2-utils

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

# Create htpasswd file with user:password
RUN htpasswd -cb /etc/nginx/.htpasswd user password

EXPOSE 80