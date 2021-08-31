import org.beangle.parent.Dependencies._
import org.beangle.parent.Settings._

ThisBuild / organization := "org.beangle.sas"
ThisBuild / version := "0.9.0"

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

val beangle_data_jdbc = "org.beangle.data" %% "beangle-data-jdbc" % "5.3.24"
val beangle_boot = "org.beangle.boot" %% "beangle-boot" % "0.0.24"
val beangle_template_freemarker = "org.beangle.template" %% "beangle-template-freemarker" % "0.0.33"

val tomcat_catalina = "org.apache.tomcat" % "tomcat-catalina" % "10.0.10"
val tomcat_juli = "org.apache.tomcat" % "tomcat-juli" % "10.0.10"
val undertow_servlet = "io.undertow" % "undertow-servlet" % "2.2.10.Final"

val commonDeps = Seq(beangle_boot, scalaxml, beangle_data_jdbc, scalatest,tomcat_catalina, undertow_servlet)

lazy val root = (project in file("."))
  .settings()
  .aggregate(core, shell, juli,server)

lazy val core = (project in file("core"))
  .disablePlugins(AssemblyPlugin)
  .settings(
    name := "beangle-sas-core",
    common,
    crossPaths := false,
    libraryDependencies ++= commonDeps
  )

lazy val shell = (project in file("shell"))
  .disablePlugins(AssemblyPlugin)
  .settings(
    name := "beangle-sas-shell",
    common,
    crossPaths := false,
    libraryDependencies ++= commonDeps,
    libraryDependencies ++= Seq(beangle_template_freemarker)
  ).dependsOn(core)

lazy val juli = (project in file("juli"))
  .settings(
    name := "beangle-sas-juli",
    common,
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
      case PathList("META-INF", xs @ _*) =>
        xs map(_.toLowerCase) match {
          case ("manifest.mf" :: Nil) | ("notice" :: Nil) | ("license" :: Nil) =>MergeStrategy.discard
          case "maven" :: xs =>  MergeStrategy.discard
          case "services" :: "javax.servlet.servletcontainerinitializer"::Nil  => MergeStrategy.discard
          case "services" :: "org.apache.commons.logging.logfactory"::Nil  => MergeStrategy.discard
          case _ => MergeStrategy.first
        }
      case _ =>
        MergeStrategy.first
    }
  )

lazy val server = (project in file("server"))
  .disablePlugins(AssemblyPlugin)
  .settings(
    name := "beangle-sas",
    common,
    crossPaths := false,
    artifact := Artifact(moduleName.value, "zip", "zip")
  )

publish / skip := true
