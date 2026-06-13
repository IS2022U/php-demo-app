# Use a pinned, specific version tag — never use a mutable 'latest' in production
FROM php:8.1.29-apache

# Add metadata labels
LABEL maintainer="IS2022U" \
      version="2.0" \
      description="PHP Demo App — GitOps with ArgoCD"

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY index.php .
COPY health.php .

# Set correct file permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Add a health check so Docker (and Kubernetes) knows if the container is alive
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost/health.php || exit 1

# Expose port 80
EXPOSE 80

# Run Apache as the non-root www-data user (already default in this image)
USER www-data
