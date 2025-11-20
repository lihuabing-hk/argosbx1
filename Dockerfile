# Node 20
FROM node:20-slim

ENV NODE_ENV=production
ENV PORT=8080
ENV UUID=replace-with-your-uuid
ENV DOMAIN=replace-with-your-domain

WORKDIR /app

# 安装原生模块依赖编译工具
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3 \
    g++ \
    make \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# 复制 package 文件并安装依赖
COPY package*.json ./

# 设置 npm 镜像 + 安全安装
RUN npm config set registry https://registry.npmmirror.com/ \
    && npm install --only=production --unsafe-perm

# 拷贝项目文件
COPY . .

# 确保脚本可执行
RUN chmod +x whm.sh || true

# 暴露端口
EXPOSE 8080

# 启动命令
CMD ["sh", "-c", "PORT=${PORT:-8080} node app.js"]
