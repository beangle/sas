import sbt.*
import sbt.Keys.*
import sbtassembly.AssemblyPlugin
import sbtassembly.AssemblyPlugin.autoImport.*
import sbtassembly.{MergeStrategy, PathList}

organization := "org.beangle.sas"
version := "0.13.11-SNAPSHOT"

scmInfo := Some(
  ScmInfo(
    url("https://github.com/beangle/sas"),
    "scm:git@github.com:beangle/sas.git"
  )
)

developers := List(
  Developer(
    id = "chaostone",
    name = "Tihua Duan",
    email = "duantihua@gmail.com",
    url = url("http://github.com/duantihua")
  )
)

description := "The Beangle Simple Application Server (SAS)"
homepage := Some(url("https://beangle.github.io/sas/index.html"))

organizationName := "The Beangle Software"
licenses += ("GNU Lesser General Public License version 3", url("http://www.gnu.org/licenses/lgpl-3.0.txt"))
startYear := Some(2005)

scalaVersion := "3.3.7"
scalacOptions := Seq("-Xtarget:21", "-deprecation", "-feature")
javacOptions := Seq("--release", "21", "-encoding", "utf-8")
Compile / doc / javacOptions ++= Seq("-Xdoclint:none")
crossPaths := false

publishMavenStyle := true
publishConfiguration := publishConfiguration.value.withOverwrite(true)
publishM2Configuration := publishM2Configuration.value.withOverwrite(true)
publishLocalConfiguration := publishLocalConfiguration.value.withOverwrite(true)
versionScheme := Some("early-semver")
pomIncludeRepository := { _ => false } // Remove all additional repository other than Maven Central from POM
credentials += Credentials(Path.userHome / ".sbt" / "sonatype_central_credentials")
publishTo := localStaging.value
resolvers += Resolver.mavenLocal
//只发布强依赖的库
pomPostProcess := { (rootNode: scala.xml.Node) =>
  def processNode(node: scala.xml.Node): scala.xml.Node = node match {
    case e: scala.xml.Elem if e.label == "dependencies" =>
      val filted = e.child.filter {
        case dep: scala.xml.Elem if dep.label == "dependency" =>
          val scope = (dep \ "scope").text
          val optional = (dep \ "optional").text
          !scope.equals("test") && !optional.equals("true")
        case _ => true
      }
      e.copy(child = filted.map(processNode))

    case e: scala.xml.Elem => e.copy(child = e.child.map(processNode))
    case other => other
  }

  processNode(rootNode)
}

val beangle_commons_ver = "6.2.1"
val beangle_template_ver = "0.2.8"
val beangle_boot_ver = "0.1.28"
val apache_tomcat_ver = "11.0.24"
val io_undertow_ver = "2.4.2.Final"
val undertow_ee_ver = "2.0.1.Final"

val beangle_commons = "org.beangle.commons" % "beangle-commons" % beangle_commons_ver
val beangle_boot = "org.beangle.boot" % "beangle-boot" % beangle_boot_ver
val beangle_template = "org.beangle.template" % "beangle-template" % beangle_template_ver
val scalatest = "org.scalatest" %% "scalatest" % "3.2.19" % "test"
val freemarker = "org.freemarker" % "freemarker" % "2.3.34"
val slf4j = "org.slf4j" % "slf4j-api" % "2.0.17"
val logback_core = "ch.qos.logback" % "logback-core" % "1.5.32"
val logback_classic = "ch.qos.logback" % "logback-classic" % "1.5.32"

val tomcat_juli = "org.apache.tomcat" % "tomcat-juli" % apache_tomcat_ver
val undertow_core = "io.undertow" % "undertow-core" % io_undertow_ver % "optional"
val undertow_servlet = "io.undertow.ee" % "undertow-servlet" % undertow_ee_ver % "optional"
val tomcat_embeded_core = ("org.apache.tomcat.embed" % "tomcat-embed-core" % apache_tomcat_ver % "optional").exclude("org.apache.tomcat", "tomcat-annotations-api")
val commonDeps = Seq(beangle_commons, beangle_boot, scalatest)
val jcl_over_slf4j = "org.slf4j" % "jcl-over-slf4j" % "2.0.18"

lazy val root = (project in file("."))
  .aggregate(core, engine, juli, server)

lazy val core = (project in file("core"))
  .settings(
    name := "beangle-sas-core",
    libraryDependencies ++= commonDeps,
    libraryDependencies ++= Seq(beangle_template, freemarker)
  )

lazy val engine = (project in file("engine"))
  .settings(
    name := "beangle-sas-engine",
    libraryDependencies ++= Seq(tomcat_embeded_core, undertow_core, undertow_servlet)
  )

lazy val juli = (project in file("juli"))
  .settings(
    name := "beangle-sas-juli",
    exportJars := false,
    scalacOptions := Seq("-deprecation", "-feature"),
    javacOptions := Seq("--release", "21", "-encoding", "utf-8"),
    libraryDependencies ++= Seq(slf4j, jcl_over_slf4j, logback_core, logback_classic, tomcat_juli),
    assemblyPackageScala / assembleArtifact := false,
    assemblyExcludedJars := {
      val cp = (assembly / fullClasspath).value
      cp filter { f => f.data.name.contains("scala") }
    },
    assemblyShadeRules := Seq(
      ShadeRule.zap("scala.**").inAll,
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
    packageBin / artifact := Artifact(moduleName.value).withType("zip").withExtension("zip")
  )

LocalRootProject / publish / skip := true
