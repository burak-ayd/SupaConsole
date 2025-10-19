# 1️⃣ Base image: Docker + Alpine
FROM docker:24.0.6-dind

# Çalışma dizini
WORKDIR /app

# Git, bash ve Node.js kurulumu
RUN apk add --no-cache \
    git \
    bash \
    nodejs \
    npm

# Production için bağımlılıkları kur
COPY package*.json ./
RUN npm ci --only=production

# Uygulama kodlarını kopyala
COPY . .

# Uygulamayı build et
RUN npm run build

# Port ayarı
EXPOSE 3000

# Docker daemon başlatmak için entrypoint
# Node uygulamasını da aynı container içinde çalıştırır
ENTRYPOINT ["sh", "-c", "dockerd-entrypoint.sh & npm start"]
