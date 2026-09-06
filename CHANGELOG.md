# Changelog

本项目所有重要变更均记录在此文件中。

## [0.13.12] - 2026-09-06

### Added
- 补充 GraalVM native-image 反射与资源注册配置（`reflect-config.json`、`resource-config.json`），覆盖 Tomcat 内部类与 SAS 引擎

### Changed
- Tomcat 升级到 11.0.25，Undertow 2.4.3.Final / undertow-servlet 2.0.2.Final，logback 1.6.3，freemarker 2.3.35
- beangle-commons 升级到 6.3.2，beangle-template 0.2.11，beangle-boot 0.1.29，jcl-over-slf4j 2.0.19
- 构建升级到 sbt 2.0.8、sbt-beangle-parent 0.16.2，新增 sbt-beangle-build 0.1.5
- native-image 下 `Server.Config.guessDocBase` 不再依赖 classpath 探测，直接使用默认 webapps 目录

### Fixed
- 修复 native-image 启动时解析 `mbeans-descriptors.xml` 失败：禁用 MBean 注册改在 `TomcatServerBuilder.build()` 入口调用 `Registry.disableRegistry()`；`org.apache.tomcat.util.modeler.disable` 等系统属性 Tomcat 并不读取，予以移除，JVM 嵌入式模式同样不再注册 MBean
- native-image 下跳过 `Desktops.openBrowser`，避免 AWT 初始化触发 JNI 致命错误
- `guessDocBase` 在 classpath 资源缺失（如 native-image）时不再抛出空指针异常

### Removed
- 移除 engine 内嵌的 `native-image-args.txt`

## [0.13.11] - 2026-08-07

### Added
- Tomcat Connector 默认启用虚拟线程（JDK 21+），并移除 `maxThreads` / `minSpareThreads` 配置
- 构建迁移到 sbt 2.0.x，复用 `sbt-beangle-parent` 0.16.1 公共设置与依赖管理
- `launch.sh` 参数顺序无关，JVM 选项（`-Xmx`、`-D`）可放在任意位置

### Changed
- Undertow 升级到 2.4.2.Final，servlet 迁移到 `io.undertow.ee`（undertow-servlet 2.0.1.Final）
- beangle-commons 升级到 6.2.2，beangle-template 0.2.8，beangle-boot 0.1.28
- Tomcat 升级到 11.0.24，slf4j 2.0.18，logback 1.6.1，logback-access 2.0.14
- Scala 升级到 3.3.8（scala-library 2.13.18）
- `logo` 渲染从 `Version` 重构为 `Logo`
- server 部署版仅对 Tomcat 11 生成 `useVirtualThreads`，兼容 Tomcat 10.x
- 嵌入式模式 classpath 补充 `jul-to-slf4j` 桥接，Tomcat JUL 日志可接入 SLF4J/Logback

### Fixed
- 修复 Tomcat 11 生成的默认 web.xml 命名空间错误，按版本渲染 Servlet 6.1 / 6.0 / 5.0
- 修复 Webapp `jspSupport` 配置未解析导致 JSP 无法启用
- 修复 Undertow 非根 contextPath 前缀路由失效、`direct-buffers` 误用 `setBufferSize`
- 修复 Undertow Bootstrap 误用 Tomcat logger
- 修复 `launch.sh` 的 `--path` 未传给 Bootstrap 导致解压目录与 docBase 不一致
- `Desktops.openBrowser` 增加异常防护，不再因打开浏览器失败而中断服务器启动
- `Firewall.apply` 改用 ProcessBuilder 并校验 `firewall-cmd` 退出码
- `start.sh` 使用 `$SERVER_BASE` 替代循环变量 `$dir`

### Removed
- Tomcat 侧 HTTP/2 与 HTTPS 支持（改由前端代理承担）
- Connector `compression*` 配置
- Vibed 引擎支持（`VibedMaker`）
- `juli.logback.configurationFile` 系统属性支持（`SLF4JConfigurator` 固定查找 `conf/logback-catalina.xml`）

## [v0.13.10] - 2026-04-12

### Added
- HTTP/2 支持
- gzip 压缩

### Changed
- 升级到 commons 6.1.0

## [v0.13.9] - 2026-02-06

### Changed
- 升级到 commons 6
- 新增路径规范化（normalize path）函数

## [v0.13.8] - 2025-12-08

### Added
- 支持 Undertow 空路径部署（empty path）

## [v0.13.7] - 2025-12-08

### Added
- 支持嵌入模式启动外部 war
- 支持 Undertow 打印 logo
- 启动时合适的清理（suitable cleanup）

### Fixed
- 修复 `restart.sh`

## [v0.13.6] - 2025-11-25

### Changed
- 升级 parent 0.15.1
- 移除更多 Tomcat jar

### Fixed
- 修复 catalina 日志重复打印

## [v0.13.5] - 2025-11-12

### Added
- 支持将其他日志系统桥接到 SLF4J
- 支持更多 Tomcat Connector 配置

### Changed
- 开发模式禁用 APR

## [v0.13.4] - 2025-09-26

### Added
- 增强 Undertow initializers
- Nginx 重定向 host 支持

### Fixed
- 修复 `pull server.xml` 404 错误

## [v0.13.3] - 2025-08-05

### Changed
- 升级 boot 0.1.18

## [v0.13.2] - 2025-08-05

### Added
- 支持从仓库下载 SNAPSHOT
- 支持解析最新 SNAPSHOT 版本
- 支持解析 `sas_remote_url` 占位

### Changed
- 升级 boot 0.1.17

## [v0.13.1] - 2025-07-30

### Added
- 支持 SNAPSHOT 扩展库（extended libs）

## [v0.13.0] - 2025-07-30

### Added
- 支持将扩展库（extended lib）部署到 webapp context
- 端口检测（CmdOptions）
- Websocket 支持

### Changed
- 适配 Tomcat 10 / 11
- 升级 parent 0.13.10，boot 0.1.6
- 简化 `EmbeddedClassLoader`

### Fixed
- 修复端口检测错误

## [v0.12.x]

### Added
- 支持 restart
- logback-classic 集成
- `DependencyClassLoader` 增加 `enableNotFoundClassResourceCache`

### Changed
- 升级到 commons 5.6.11、Scala 3.3.4、logback access 2.0.4
- 移除 tomcat-native 依赖，Java 11 装配

### Fixed
- 修复若干 bug
