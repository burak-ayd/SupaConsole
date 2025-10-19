# =========================
# Base image: Ubuntu + Node.js
# =========================
FROM ubuntu:22.04

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

# Docker resmi GPG key ve repo ekleme
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && chmod a+r /etc/apt/keyrings/docker.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Docker paketlerini yükle
RUN apt-get update && apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

# Node.js ve npm kurulumu
RUN apt-get update && apt-get install -y nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# Docker kullanımı için kullanıcı ekleme
RUN usermod -aG docker $USER


# Paketleri kopyala ve build
COPY . .
RUN npm ci --only=production


RUN npm run build

EXPOSE 3000
CMD ["npm", "start"]
