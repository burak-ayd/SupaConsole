# =========================
# Base image: Ubuntu + DinD
# =========================
FROM docker:24.0.6-dind

# Çalışma dizini
WORKDIR /app

# Temel paketler kurulumu
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    lsb-release \
    git \
    bash \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Node.js 18 kurulumu
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# Uygulama kodlarını kopyala ve bağımlılıkları kur
COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# Port ayarı
EXPOSE 3000

# Docker daemon + Node.js uygulamasını aynı anda başlat
ENTRYPOINT ["sh", "-c", "dockerd-entrypoint.sh & npm start"]
