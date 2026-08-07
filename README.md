# Beangle SAS

简化和便捷 war 包发布、加强管理的定制应用服务器，基于 Tomcat 与 Undertow 构建。

## 特性

- **多实例管理**：一套安装目录下，通过配置文件管理多个 JVM/应用实例（Farm / Server），支持一键启停、状态查看
- **双引擎支持**：Tomcat 11（JDK 21 虚拟线程）与 Undertow 2.4，按实例选择
- **嵌入模式**：`launch.sh` 直接启动单个 war / Maven 坐标 / 远端 URL，无需手工配置
- **依赖自动解析**：通过 `beangle-boot` 从 Maven 仓库解析并下载 war 及其传递依赖
- **远程配置分发**：`sas.sh pull` 从控制端拉取 `server.xml`，`start.sh` 启动前自动检查远端配置
- **统一日志**：`juli` 模块将 Tomcat 日志桥接到 SLF4J / Logback，集中管理
- **代理与防火墙配置生成**：自动生成 Nginx / HAProxy 反向代理配置与防火墙规则
- **JNDI 资源与 Realm**：支持 Webapp 级 JNDI 资源引用与安全域配置

## 架构

```
beangle-sas
├── core     # 配置模型、部署生成器（Maker）、管理工具（Proxy/Firewall/Resolver 等）
├── engine   # Tomcat / Undertow 嵌入式运行时
├── juli     # Tomcat juli → SLF4J/Logback 日志桥接（shaded 独立 jar）
└── server   # 发行包：安装与启动脚本、bin/lib 依赖
```

## 快速开始

### 网络安装

```bash
./netinstall.sh            # 默认安装 0.13.11
./netinstall.sh 0.13.10    # 指定版本
```

### 嵌入模式（单应用启动）

```bash
launch.sh /path/to/app.war [--port=8080] [--path=/app] [jvm_options]
launch.sh group:artifact:version [--engine=undertow] [other_args]
launch.sh http://host.com/path/app.war [other_args]
```

### 多实例模式

1. 编辑 `conf/server.xml`，声明引擎、实例（Farm/Server）与应用（Webapp）
2. 启动：`bin/start.sh farm_name`（或 `server_name`、`all`）
3. 停止：`bin/stop.sh all`

### 管理命令

```bash
bin/sas.sh status     # 查看运行中的实例
bin/sas.sh version    # 显示版本
bin/sas.sh proxy      # 生成 Nginx/HAProxy 配置
bin/sas.sh firewall   # 生成防火墙配置
bin/sas.sh aes key plain|encoded   # AES 加解密
bin/sas.sh resolve    # 解析 server.xml 依赖
bin/sas.sh pull       # 从控制端拉取 server.xml
bin/sas.sh update 0.13.11   # 升级到指定版本
```

## 配置（conf/server.xml）

配置文件通过 `<Sas>` 根元素声明，主要组成：

| 元素 | 说明 |
| --- | --- |
| `Repository` | 依赖本地/远程仓库（release） |
| `SnapshotRepo` | SNAPSHOT 仓库，支持 `${sas_remote_url}` 占位 |
| `Engines/Engine` | 引擎定义（Tomcat / Undertow），含版本、JSP 支持、Listener、Jar |
| `Hosts/Host` | 主机定义（name/ip） |
| `Resources/Resource` | JNDI 资源，供 Webapp 引用 |
| `Farms/Farm` | 实例组：堆大小、访问日志、HTTP Connector、Server 列表 |
| `Webapps/Webapp` | 应用：uri、contextPath、runAt（部署目标）、libs、ResourceRef |
| `Proxy` | 前端代理（Nginx/HAProxy）：后端映射、HTTPS、状态页 |

## 构建

```bash
sbt compile    # 编译
sbt test       # 测试
sbt package    # 打包（juli assembly + server zip）
```

- sbt 2.0.x / Scala 3.3.x / JDK 21+
- 依赖管理基于 [sbt-beangle-parent](https://github.com/beangle/parent)

## License

GNU Lesser General Public License version 3 (LGPL-3.0)
