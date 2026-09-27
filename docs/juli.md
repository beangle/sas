# beangle-sas-juli 模块备忘

> 一句话定位：`juli` 模块产出 `beangle-sas-juli-<version>.jar`，一个**整体改名（shade）的自包含 fat jar**，
> 为 SAS 托管的 Tomcat 进程提供「JULI → SLF4J → Logback」日志链路，且与部署应用自带的 slf4j/logback 完全隔离。

## 1. 背景与作用

- Tomcat 自带的 `org.apache.juli.logging.LogFactory` 默认落到 `java.util.logging`，SAS 希望容器日志统一走 Logback
  （由 `conf/logback-catalina.xml` 配置）。
- 同一个 JVM 里，**部署的应用通常自带普通版 `org.slf4j` + `ch.qos.logback`**。如果容器日志也用同一套，
  两边的配置、初始化时机、版本会互相干扰。
- 方案：把 slf4j、logback、jcl-over-slf4j、tomcat-juli 等依赖在**打包时整体改名**塞进一个 jar，
  进程内同时存在两套互不相干的 logging 栈：

  | 使用方 | logging 栈 |
  |---|---|
  | 托管的 Tomcat 容器（bootstrap 启动） | `org.beangle.sas.slf4j` / `org.beangle.sas.logback`（jar 内自带） |
  | 部署的应用（webapp / 引擎嵌入模式） | 普通 `org.slf4j` / `ch.qos.logback`（应用自己的依赖） |

## 2. 构建机制

配置见 `build.sbt` 的 `lazy val juli` 段。

- **发布产物即 fat jar**：`Compile / packageBin := Def.uncached(assembly).value`，
  `assemblyJarName := "beangle-sas-juli-" + version + ".jar"`。`publishLocal`/`publishM2` 出来的就是它。
- 编译依赖（打包时全部内嵌，随后 shade）：`slf4j`、`jcl-over-slf4j`、`logback-core`、`logback-classic`、`tomcat-juli`。
- 模块自有源码只有一个 Java 类：`SLF4JConfigurator`。

### 2.1 Shade 规则

| 规则 | 作用 |
|---|---|
| `rename org.slf4j.** → org.beangle.sas.slf4j.@1` | slf4j API 整体改名 |
| `rename ch.qos.logback.** → org.beangle.sas.logback.@1` | logback 整体改名 |
| `rename org.apache.commons.logging.** → org.apache.juli.logging.@1` | jcl-over-slf4j "变身"为 JULI 的 LogFactory/Log |
| `zap org.apache.juli.logging.**` | 剔除 tomcat-juli 原生的 LogFactory（让上面的 rename 产物接管） |
| `zap org.apache.juli.**Handler**`、`**Format**` | 去掉 JUL 默认的 handler/format，日志统一进 SLF4J |
| `zap scala.**` | 防御性剔除（本模块无 Scala 代码） |
| `rename logback.ContextSelector → juli.logback.ContextSelector` | 避免与应用侧 logback 的 ContextSelector 冲突 |

Merge 策略（`assemblyMergeStrategy`）：丢弃 logback/slf4j/commons-logging 的**原始** `META-INF/services` 文件、
`module-info.class`、manifest/maven/license 等；其余取 first。

### 2.2 服务文件必须预先用 shade 后的名字写好

**资源文件不会被 rename**，所以 `juli/src/main/resources` 里的服务文件与配置是直接按目标名写的：

```
META-INF/services/org.beangle.sas.slf4j.spi.SLF4JServiceProvider
    → org.beangle.sas.logback.classic.spi.LogbackServiceProvider
META-INF/services/org.beangle.sas.logback.classic.spi.Configurator
    → org.beangle.sas.tomcat.juli.SLF4JConfigurator
META-INF/services/org.apache.juli.logging.LogFactory
    → org.apache.juli.logging.impl.SLF4JLogFactory
```

同样，内置默认配置 `logback-catalina.xml` 里的 appender/statusListener 类名写的也是
`org.beangle.sas.logback.core.*`（shade 后的名字）。

### 2.3 对 Java 版本敏感

shade 由 jarjar/ASM 完成，**ASM 版本决定能读取的 class 文件 major 版本**。
parent 中 `javacOptions --release` 提升后，必须同步确认 sbt-assembly 足够新。

## 3. 运行时机制

### 3.1 启动链（Tomcat 托管模式）

`bin/start.sh`：

```bash
CLASSPATH="$SERVER_BASE/bin/bootstrap.jar:$SAS_HOME/bin/lib/beangle-sas-juli-$beangle_sas_ver.jar"
java -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager \
     -Dsas.home="$SAS_HOME" -Dcatalina.base=... org.apache.catalina.startup.Bootstrap start
```

- juli jar 位于**系统类路径**且靠前，JVM parent-first 委派使容器代码拿到的
  `org.apache.juli.logging.LogFactory` 是 fat jar 内的 `SLF4JLogFactory`（而不是 tomcat-embed 里的原生实现）。
- `-Dsas.home` 是 `SLF4JConfigurator` 定位配置文件的依据。
- TomcatMaker 生成引擎目录时会**删除 tomcat 自带的 `tomcat-juli.jar`**（`TomcatMaker.scala` 注释
  "remove tomcat-juli,using beangle-sas-juli"），由本 jar 顶替。

### 3.2 日志链路

```
容器 commons-logging 调用
  → org.apache.juli.logging.LogFactory/SLF4JLogFactory   (jcl-over-slf4j shade 而来)
  → org.beangle.sas.slf4j.LoggerFactory                   (shaded slf4j)
  → ServiceLoader: org.beangle.sas.slf4j.spi.SLF4JServiceProvider
  → org.beangle.sas.logback.classic.spi.LogbackServiceProvider   (shaded logback)
  → ClassicEnvUtil.loadFromServiceLoader(Configurator)
  → SLF4JConfigurator.configure()
       1) 读取 $sas.home/conf/logback-catalina.xml（存在则用）
       2) 否则用 jar 内置默认（console 输出，root=INFO）
       3) 返回 DO_NOT_INVOKE_NEXT_IF_ANY，禁止其他内置 Configurator
```

### 3.3 隔离性（两个方向都成立）

- **应用侧有普通 logback**：两边包名不同，互不影响（ems portal 等应用正常用 `ch.qos.logback`）。
- **运行时没有外部 logback**：juli 自带 shaded logback，独立可运行（前提是 shade 完整，见 §5 自检清单）。

### 3.4 哪些模式不用 juli

引擎嵌入模式（`launch.sh` / ems native，`beangle-sas-engine` + 普通 slf4j + 真 logback jar）
**不加载 juli jar**，直接使用普通 logging 栈。juli 只服务 `start.sh` 托管的 Tomcat 进程。

## 4. 用法

- **安装**：`init.sh` 的 `artifacts` 清单会下载并软链到 `$SAS_HOME/bin/lib/`；
  jar 名中的版本取自 `env.sh` 的 `beangle_sas_ver`，与发布版本必须一致。
- **自定义容器日志**：编辑 `$SAS_HOME/conf/logback-catalina.xml`。
  ⚠️ **appender、listener 等类名必须写 shade 后的 `org.beangle.sas.logback.*`**，写 `ch.qos.logback.*` 会 ClassNotFound。
  内置默认模板：`juli/src/main/resources/logback-catalina.xml`。
- **升级**：发布新版本后同步 `env.sh` 的 `beangle_sas_ver`（以及 `init.sh`/`start.sh` 无需改动，按变量取值）。
- **关于外置 logback**：托管模式不依赖外置 logback；引擎模式需要。两者互不替代。

## 5. 发版自检清单

```bash
# 1) 构建日志无 "Shading is therefore impossible"

# 2) 无未 shade 残留（应输出 0）
unzip -p beangle-sas-juli-<ver>.jar org/beangle/sas/tomcat/juli/SLF4JConfigurator.class \
  | strings | grep -c ch/qos

# 3) 三个服务文件齐全且指向 shade 名
unzip -l beangle-sas-juli-<ver>.jar | grep META-INF/services

# 4) 纯 fat jar 冒烟（classpath 只有该 jar，能初始化 Logger 并输出日志）
```

## 6. 关键文件索引

| 文件 | 内容 |
|---|---|
| `build.sbt`（`lazy val juli` 段） | assembly、shade 规则、merge 策略 |
| `juli/src/main/java/org/beangle/sas/tomcat/juli/SLF4JConfigurator.java` | 唯一源码类，配置加载入口 |
| `juli/src/main/resources/logback-catalina.xml` | 内置默认容器日志配置（shade 后类名） |
| `juli/src/main/resources/META-INF/services/*` | 预先写好 shade 名的服务文件 |
| `server/src/main/resources/bin/env.sh` | `beangle_sas_ver` 版本变量 |
| `server/src/main/resources/bin/init.sh` | artifacts 清单（下载/软链到 bin/lib） |
| `server/src/main/resources/bin/start.sh` | 托管启动 classpath 装配 |
| `core/src/main/scala/org/beangle/sas/maker/TomcatMaker.scala` | 删除 tomcat 自带 tomcat-juli.jar |
