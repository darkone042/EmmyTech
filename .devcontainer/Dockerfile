FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:ondrej/php -y \
    && apt-get update && apt-get install -y \
    php8.2 \
    php8.2-intl \
    php8.2-mbstring \
    php8.2-mysql \
    php8.2-xml \
    php8.2-curl \
    php8.2-zip \
    php8.2-gd \
    mysql-client \
    curl \
    wget \
    git \
    unzip \
    zip \
    docker.io \
    chromium-browser \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Install megatools
RUN apt-get update && apt-get install -y megatools

# Install Cloudflare Tunnel
RUN curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared \
    && chmod +x /usr/local/bin/cloudflared

# Install OpenCode via npm (correct way)
RUN npm install -g opencode-ai

# Install OmniRoute globally
RUN npm install -g omniroute

WORKDIR /workspace
