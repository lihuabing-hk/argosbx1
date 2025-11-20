# 使用官方 Node.js 20 Debian 镜像
FROM node:20-bullseye

# 设置环境变量
ENV NODE_ENV=production
ENV PORT=8080
ENV UUID=replace-with-your-uuid
ENV DOMAIN=replace-with-your-domain

# 设置工作目录
WORKDIR /app

# 安装原生依赖（canvas/sharp 等需要）
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential python3 g++ make libcairo2-dev \
    libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev \
    ca-certificates git \
 && rm -rf /var/lib/apt/lists/*

# 拷贝 package.json 和 package-lock.json
COPY container/nodejs/package*.json ./

# 设置 npm 镜像并安装生产依赖
RUN npm config set registry https://registry.npmmirror.com/ \
    && npm install --only=production --unsafe-perm

# 拷贝整个项目
COPY . .

# 确保启动脚本可执行（如果有）
RUN chmod +x whm.sh || true

# 暴露端口
EXPOSE 8080

# 启动入口文件
CMD ["sh", "-c", "PORT=${PORT:-8080} node container/nodejs/index.js"]
