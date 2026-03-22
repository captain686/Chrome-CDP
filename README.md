# Chrome-CDP

---

## 🚀 项目简介
Chrome-CDP 是一个基于 Docker 的项目，提供了一个安全的 Chrome 浏览器环境，支持远程调试协议（Chrome DevTools Protocol）。

---

## ✨ 功能特性
- 🔒 提供安全的 Chrome 浏览器容器化环境。
- 🛠️ 支持远程调试协议（Chrome DevTools Protocol）。
- 📦 使用 GitHub Container Registry 托管镜像。
- 🤖 自动化构建和部署。

---

## 🏃 快速开始

### 1️⃣ 克隆项目
```bash
git clone https://github.com/captain686/Chrome-CDP.git
cd Chrome-CDP
```

### 2️⃣ 启动容器
确保已安装 Docker 和 Docker Compose。

```bash
docker-compose up -d
```

### 3️⃣ 访问服务
- 🖥️ VNC 端口：`5900`
- 🌐 Chrome DevTools 端口：`9222`

访问 `http://localhost:9222` 查看调试页面。

---

## ⚙️ 配置说明

### Docker Compose 配置
- 📂 `volumes`：将主机目录挂载到容器内的 `/data/chrome-profile`。
- 👤 `user`：确保容器内的文件归属非 root 用户。
- 🖼️ `image`：使用 GitHub Container Registry 中的镜像。

### 环境变量
- 🌈 `DISPLAY`：设置为 `:1`。

---

## 🛠️ 开发与构建

### 构建镜像
```bash
docker build -t chrome-cdp:latest .
```

---

## 🤖 GitHub Actions
项目已配置 GitHub Actions 自动化工作流：
- 在 `main` 分支推送时自动构建并推送镜像到 GitHub Container Registry。

---

## 🤝 贡献指南
欢迎提交 Issue 和 Pull Request！

---

## 📜 许可证
本项目采用 MIT 许可证。详情请参阅 [LICENSE](LICENSE)。