# =========================
# 1️⃣ Builder: Tüm bağımlılıklarla build
# =========================
FROM node:18-alpine AS builder

# Çalışma dizini
WORKDIR /app

# Git ve bash kurulumu (Alpine)
RUN apk add --no-cache git bash curl python3 py3-pip

# Node ve npm zaten node:18-alpine ile geliyor

# Tüm bağımlılıkları kur (dev + prod)
COPY package*.json ./
RUN npm ci

# Uygulama kodlarını kopyala ve build et
COPY . .
RUN npm run build

# =========================
# 2️⃣ Runner: Production only
# =========================
FROM docker:24.0.6-dind AS runner

WORKDIR /app
ENV NODE_ENV=production

# Git ve bash kurulumu
RUN apk add --no-cache git bash curl python3 py3-pip \
    && pip install docker-compose

# Sadece prod bağımlılıkları kur
COPY package*.json ./
RUN npm ci --omit=dev

# Build çıktısını ve public klasörünü kopyala
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json

# Port ayarı
EXPOSE 3000

# Docker daemon ve Node uygulamasını başlat
ENTRYPOINT ["sh", "-c", "dockerd-entrypoint.sh & npm start"]
