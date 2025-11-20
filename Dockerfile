FROM node:20-bullseye

ENV NODE_ENV=production
ENV PORT=8080
ENV UUID=replace-with-your-uuid
ENV DOMAIN=replace-with-your-domain

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential python3 g++ make libcairo2-dev \
    libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev \
    ca-certificates git \
 && rm -rf /var/lib/apt/lists/*

# 拷贝 package.json
COPY container/nodejs/package*.json ./

RUN npm config set registry https://registry.npmmirror.com/ \
    && npm install --only=production --unsafe-perm

# 拷贝整个项目
COPY . .

# 确保 start.sh 可执行
RUN chmod +x container/nodejs/start.sh

EXPOSE 8080

# 使用绝对路径启动
CMD ["sh", "-c", "PORT=${PORT:-8080} container/nodejs/start.sh"]
