FROM node:20-bullseye

ENV NODE_ENV=production
ENV PORT=8080
ENV UUID=replace-with-your-uuid
ENV DOMAIN=replace-with-your-domain

WORKDIR /app

# 安装原生模块编译依赖和 canvas/sharp 所需库
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3 \
    g++ \
    make \
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libgif-dev \
    librsvg2-dev \
    ca-certificates \
    git \
 && rm -rf /var/lib/apt/lists/*

# 拷贝 package 文件
COPY package*.json ./

# npm 镜像 + 安装依赖
RUN npm config set registry https://registry.npmmirror.com/ \
    && npm install --only=production --unsafe-perm

# 拷贝整个项目
COPY . .

# 确保启动脚本可执行
RUN chmod +x whm.sh || true

# 暴露端口
EXPOSE 8080

# 启动命令
CMD ["sh", "-c", "PORT=${PORT:-8080} node app.js"]
