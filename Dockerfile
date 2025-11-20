# 使用 Node 20 兼容最新依赖
FROM node:20-slim

# 设置默认环境变量
ENV NODE_ENV=production
ENV PORT=8080
ENV UUID=replace-with-your-uuid
ENV DOMAIN=replace-with-your-domain

# 设置工作目录
WORKDIR /app

# 安装系统依赖，保证原生模块编译成功
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3 \
    g++ \
    make \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# 拷贝 package.json 并安装依赖
COPY package*.json ./
RUN npm config set registry https://registry.npmmirror.com/ \
    && npm install --only=production

# 拷贝整个项目文件
COPY . .

# 确保脚本可执行（如果 argosbx1 有启动脚本）
RUN chmod +x whm.sh || true

# 暴露端口
EXPOSE 8080

# 启动命令，使用环境变量 PORT
CMD ["sh", "-c", "PORT=${PORT:-8080} node app.js"]
