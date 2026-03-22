FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

# 基础依赖 + 工具
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

# 安装 Google Chrome Stable
RUN wget -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get update && apt-get install -y /tmp/google-chrome.deb --no-install-recommends || \
    (apt-get -f install -y && apt-get install -y /tmp/google-chrome.deb --no-install-recommends) && \
    rm -f /tmp/google-chrome.deb && \
    rm -rf /var/lib/apt/lists/*

# 创建用户
RUN groupadd -g 1000 chromeuser && \
    useradd -u 1000 -g chromeuser -m -s /bin/bash chromeuser

# 权限修正：确保 /data 和 /tmp 权限
RUN mkdir -p /data/chrome-profile && chown -R chromeuser:chromeuser /data && \
    chmod 755 /data && \
    chmod 1777 /tmp && \
    mkdir -p /tmp/supervisor && chown chromeuser:chromeuser /tmp/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV DISPLAY=:1
WORKDIR /home/chromeuser

EXPOSE 9222 5900

# 启动前强制修复 dbus 和清理锁
CMD ["/usr/bin/bash", "-c", "rm -f /tmp/.X1-lock /tmp/supervisor/supervisor.sock && dbus-uuidgen > /etc/machine-id && /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"]