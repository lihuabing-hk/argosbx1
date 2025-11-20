# 使用官方 Node.js 20 镜像
FROM node:20-bullseye

# 设置环境变量
ENV NODE_ENV=production
ENV PORT=8080
ENV UUID=replace-with-your-uuid
ENV DOMAIN=replace-with-your-domain

# 工作目录
WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential python3 g++ make libcairo2-dev \
    libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev \
    ca-certificates git curl \
 && rm -rf /var/lib/apt/lists/*

# 拷贝 package.json 并安装依赖
COPY container/nodejs/package*.json ./
RUN npm config set registry https://registry.npmmirror.com/ \
    && npm install --only=production --unsafe-perm

# 拷贝整个项目
COPY . .

# 确保 start.sh 可执行
RUN chmod +x container/nodejs/start.sh

# 暴露端口
EXPOSE 8080

# 启动容器时执行 start.sh 并保持容器持续运行
CMD ["sh", "-c", "container/nodejs/start.sh && tail -f /dev/null"]
