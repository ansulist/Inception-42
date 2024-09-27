# Use the official NGINX base image from Docker Hub
FROM debian:12

# Install OpenSSL for certificate generation and security purposes
RUN apt-get update && apt-get install -y openssl nginx && rm -rf /var/lib/apt/lists/*

# Create directories for SSL certificate and key
RUN mkdir -p /etc/nginx/ssl

# Generate a self-signed SSL certificate (valid for 365 days)
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Copy custom NGINX configuration file for TLSv1.2 and TLSv1.3
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Expose port 443 for HTTPS traffic
EXPOSE 443

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
