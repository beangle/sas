import org.beangle.parent.Dependencies.*
import org.beangle.parent.Settings.*

ThisBuild / organization := "org.beangle.sas"
ThisBuild / version := "0.13.5-SNAPSHOT"

ThisBuild / scmInfo := Some(
  ScmInfo(
    url("https://github.com/beangle/sas"),
    "scm:git@github.com:beangle/sas.git"
  )
)

ThisBuild / developers := List(
  Developer(
    id = "chaostone",
    name = "Tihua Duan",
    email = "duantihua@gmail.com",
    url = url("http://github.com/duantihua")
  )
)

ThisBuild / description := "The Beangle Simple Application Server (SAS)"
ThisBuild / homepage := Some(url("https://beangle.github.io/sas/index.html"))
ThisBuild / crossPaths := false
Global / onChangedBuildSource := ReloadOnSourceChanges

val beangle_commons_ver = "5.6.31"
val beangle_template_ver = "0.1.27"
val beangle_boot_ver = "0.1.18"
val apache_tomcat_ver = "11.0.11"
val io_undertow_ver = "2.3.19.Final"

val beangle_commons = "org.beangle.commons" % "beangle-commons" % beangle_commons_ver
val beangle_boot = "org.beangle.boot" % "beangle-boot" % beangle_boot_ver
val beangle_template = "org.beangle.template" % "beangle-template" % beangle_template_ver

val tomcat_juli = "org.apache.tomcat" % "tomcat-juli" % apache_tomcat_ver
val undertow_servlet = "io.undertow" % "undertow-servlet" % io_undertow_ver % "optional"
val tomcat_embeded_core = "org.apache.tomcat.embed" % "tomcat-embed-core" % apache_tomcat_ver % "optional" exclude("org.apache.tomcat", "tomcat-annotations-api")
val commonDeps = Seq(beangle_commons, beangle_boot, scalaxml, scalatest)

lazy val root = (project in file("."))
  .settings()
  .aggregate(core, engine, juli, server)

lazy val core = (project in file("core"))
  .settings(
    name := "beangle-sas-core",
    common,
    libraryDependencies ++= commonDeps,
    libraryDependencies ++= Seq(beangle_template, freemarker),
    crossPaths := false
  )

lazy val engine = (project in file("engine"))
  .settings(
    name := "beangle-sas-engine",
    common,
    crossPaths := false,
    libraryDependencies ++= Seq(tomcat_embeded_core, undertow_servlet)
  )

lazy val juli = (project in file("juli"))
  .settings(
    name := "beangle-sas-juli",
    common,
    scalacOptions := Seq("-deprecation", "-feature"),
    javacOptions := Seq("-encoding", "utf-8"),
    crossPaths := false,
    libraryDependencies ++= Seq(slf4j, jcl_over_slf4j, logback_core, logback_classic, tomcat_juli),
    assemblyPackageScala / assembleArtifact := false,
    assemblyExcludedJars := {
      val cp = (assembly / fullClasspath).value
      cp filter { f => f.data.getName.contains("scala") }
    },
    assemblyShadeRules := Seq(
      ShadeRule.zap("org.apache.juli.logging.**").inAll,
      ShadeRule.zap("org.apache.juli.**Handler**").inAll,
      ShadeRule.zap("org.apache.juli.**Format**").inAll,
      ShadeRule.rename("org.apache.commons.logging.**" -> "org.apache.juli.logging.@1").inAll,
      ShadeRule.rename("org.slf4j.**" -> "org.beangle.sas.slf4j.@1").inAll,
      ShadeRule.rename("ch.qos.logback.**" -> "org.beangle.sas.logback.@1").inAll,
      ShadeRule.rename("logback.configurationFile" -> "juli.logback.configurationFile").inAll,
      ShadeRule.rename("logback.ContextSelector" -> "juli.logback.ContextSelector").inAll,
    ),
    assemblyMergeStrategy := {
      case PathList("META-INF", xs@_*) =>
        xs map (_.toLowerCase) match { //这里转成了小写，后面判断也使用小写
          case ("manifest.mf" :: Nil) | ("notice" :: Nil) | ("license" :: Nil) => MergeStrategy.discard
          case "maven" :: xs => MergeStrategy.discard
          case "services" :: "jakarta.servlet.servletcontainerinitializer" :: Nil => MergeStrategy.discard
          case "services" :: "org.slf4j.spi.slf4jserviceprovider" :: Nil => MergeStrategy.discard
          case "services" :: "org.apache.commons.logging.logfactory" :: Nil => MergeStrategy.discard
          case "services" :: "ch.qos.logback.classic.spi.configurator" :: Nil => MergeStrategy.discard
          case _ => MergeStrategy.first
        }
      case PathList("module-info.class") => MergeStrategy.discard
      case _ => MergeStrategy.first
    },
    assemblyJarName := "beangle-sas-juli-" + version.value + ".jar",
    Compile / packageBin := assembly.value
  )

lazy val server = (project in file("server"))
  .disablePlugins(AssemblyPlugin)
  .settings(
    name := "beangle-sas",
    common,
    crossPaths := false,
    packageBin / artifact := Artifact(moduleName.value, "zip", "zip")
  )

publish / skip := true
