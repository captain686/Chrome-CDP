FROM debian:12-slim

# 设置环境变量，防止安装过程中的交互式弹窗
ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    HOME=/home/chromeuser \
    XDG_CONFIG_HOME=/home/chromeuser/.config \
    XDG_CACHE_HOME=/home/chromeuser/.cache

# 1. 安装基础依赖、中文字体及工具
RUN apt-get update && apt-get install -y \
    fonts-liberation \
    fonts-wqy-zenhei \
    libnss3 \
    libgbm1 \
    libgl1-mesa-dri \
    libglx-mesa0 \
    ca-certificates \
    curl \
    dbus-x11 \
    procps \
    xvfb \
    x11vnc \
    supervisor \
    socat \
    wget \
    gnupg \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# 2. 安装 Google Chrome Stable
RUN wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get update && \
    apt-get install -y /tmp/google-chrome.deb --no-install-recommends && \
    rm -f /tmp/google-chrome.deb && \
    rm -rf /var/lib/apt/lists/*

# 3. 创建非 root 用户并预处理系统文件 (解决 Permission denied 的关键)
RUN groupadd -g 1000 chromeuser && \
    useradd -u 1000 -g chromeuser -m -s /bin/bash chromeuser && \
    # 提前生成 machine-id 并赋予读权限，这样非 root 用户启动时无需再写
    dbus-uuidgen > /etc/machine-id && \
    chmod 644 /etc/machine-id

# 4. 预创建必要的目录并修正权限
RUN mkdir -p /data/chrome-profile /tmp/supervisor /var/run/dbus && \
    chown -R chromeuser:chromeuser /data /tmp/supervisor /var/run/dbus && \
    chmod 1777 /tmp && \
    chmod 755 /data

# 5. 拷贝 Supervisor 配置文件
# 请确保当前目录下有名为 supervisord.conf 的文件
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 切换工作目录
WORKDIR /home/chromeuser

# 暴露 VNC 端口和 CDP 代理端口
EXPOSE 5900 9222

# 6. 启动指令：清理残留锁文件并启动 Supervisor
# 注意：这里删除的是上一次运行可能残留的 Unix Socket 和 Xvfb 锁
CMD ["/usr/bin/bash", "-c", "rm -f /tmp/.X1-lock /tmp/supervisor/supervisor.sock && exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"]
