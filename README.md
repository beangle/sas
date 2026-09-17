# Beangle SAS

简化和便捷 war 包发布、加强管理的定制应用服务器，基于 Tomcat 与 Undertow 构建。

## 特性

- **多实例管理**：一套安装目录下，通过配置文件管理多个 JVM/应用实例（Farm / Server），支持一键启停、状态查看
- **双引擎支持**：Tomcat 10 / 11（11 默认虚拟线程，JDK 21+）与 Undertow 2.4，按实例选择
- **嵌入模式**：`launch.sh` 直接启动单个 war / Maven 坐标 / 远端 URL，参数顺序无关，无需手工配置
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
./netinstall.sh            # 默认安装 0.13.12
./netinstall.sh 0.13.10    # 指定版本
```

### 嵌入模式（单应用启动）

参数顺序无关，JVM 选项（`-Xmx`、`-D`）可放在任意位置：

```bash
launch.sh /path/to/app.war [--port=8080] [--path=/app] [jvm_options]
launch.sh [jvm_options] group:artifact:version [--engine=undertow] [other_args]
launch.sh http://host.com/path/app.war [--port=8080] [other_args]
```

`--dev=true` 开启开发模式（热加载、错误页），等价于 `-Dbeangle.config.profiles=dev`。该 profile 与 beangle-commons 的
`Environment` 共用同一个 key 与语义（逗号分隔、调试模式自动视为 dev、`-dev` 可关闭自动行为）。

#### 引擎参数

`--Dkey=value` 设置引擎参数，等价于 JVM 的 `-Dkey=value`（同时存在时 `--D` 优先）：

```bash
launch.sh /path/to/app.war --port=8080 --Dconnector.maxKeepAliveRequests=1000 --Dengine.backgroundProcessorDelay=30
```

| key | 默认 | 说明 |
| --- | --- | --- |
| `connector.maxConnections` | 10000 | 最大连接数 |
| `connector.acceptCount` | 1000 | 等待队列长度 |
| `connector.connectionTimeout` | 20000 | 建连/读超时（ms） |
| `connector.keepAliveTimeout` | 同 connectionTimeout | keep-alive 空闲超时（ms） |
| `connector.maxKeepAliveRequests` | 100 | 单个 keep-alive 连接的最大请求数 |
| `engine.backgroundProcessorDelay` | 10（dev 5） | 容器后台处理间隔（秒），驱动会话过期、静态资源缓存回收与热加载。0 会关闭这些功能，会被夹到 1；会话实际过期粒度 = 该值 × `processExpiresFrequency`(默认 6) |
| `buffer-size`、`io-thread`、`worker-threads`、`direct-buffers` | Undertow 默认 | 仅 `--engine=undertow` 生效 |

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
bin/sas.sh update 0.13.12   # 升级到指定版本
```

## 配置（conf/server.xml）

配置文件通过 `<Sas>` 根元素声明，主要组成：

| 元素 | 说明 |
| --- | --- |
| `Repository` | 依赖本地/远程仓库（release） |
| `SnapshotRepo` | SNAPSHOT 仓库，支持 `${sas_remote_url}` 占位 |
| `Engines/Engine` | 引擎定义（Tomcat 10/11 / Undertow），含版本、JSP 支持、Listener、Jar |
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

- sbt 2.0.x / Scala 3.3.x
- 嵌入式模式需要 JDK 21+（虚拟线程）；server 部署模式 Tomcat 10.x 可用 JDK 17+，Tomcat 11 需 JDK 21+
- 依赖管理基于 [sbt-beangle-parent](https://github.com/beangle/parent)

## License

GNU Lesser General Public License version 3 (LGPL-3.0)
