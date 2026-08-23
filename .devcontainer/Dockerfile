FROM mcr.microsoft.com/devcontainers/php:8.2

# Install system dependencies
RUN apt-get update && apt-get install -y \
    php-intl \
    php-mbstring \
    php-mysql \
    php-xml \
    php-curl \
    php-zip \
    php-gd \
    mysql-client \
    curl \
    wget \
    git \
    unzip \
    zip \
    docker.io \
    chromium-browser \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHPMyAdmin
RUN apt-get update && apt-get install -y \
    phpmyadmin \
    && rm -rf /var/lib/apt/lists/*

# Install megatools
RUN apt-get update && apt-get install -y megatools

# Install Cloudflare Tunnel
RUN curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared \
    && chmod +x /usr/local/bin/cloudflared

# Install OpenCode
RUN curl -fsSL https://opencode.ai | bash

WORKDIR /workspace
