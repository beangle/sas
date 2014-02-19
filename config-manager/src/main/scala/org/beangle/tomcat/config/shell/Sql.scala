/*
 * Beangle, Agile Development Scaffold and Toolkit
 *
 * Copyright (c) 2005-2014, Beangle Software.
 *
 * Beangle is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Beangle is distributed in the hope that it will be useful.
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Beangle.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.beangle.tomcat.config.shell

import java.io.{File, FileInputStream}
import scala.Array.canBuildFrom
import org.beangle.commons.io.Files.{/ => /}
import org.beangle.commons.lang.Consoles
import org.beangle.commons.lang.Consoles.{prompt, shell,readPassword}
import org.beangle.commons.lang.Strings.{isBlank, isNotEmpty, split, substringAfter, trim}
import org.beangle.commons.lang.SystemInfo
import org.beangle.commons.logging.Logging
import org.beangle.data.jdbc.script.{OracleParser, Runner}
import org.beangle.data.jdbc.util.PoolingDataSourceFactory
import org.beangle.data.jdbc.vendor.{UrlFormat, Vendors}
import org.beangle.tomcat.config.model.{DataSource, TomcatConfig}
import java.net.URL

object Sql extends Logging {

  var dataSource: DataSource = _

  var workdir: String = _

  var sqlDir: String = _

  def main(args: Array[String]) {
    workdir = if (args.length == 0) SystemInfo.user.dir else args(0)
    sqlDir = workdir + / + "sql" + /
    if (sqlFiles.isEmpty) {
      println("Cannot find sql files in " + sqlDir)
      return
    }
    val target = new File(workdir + / + "config.xml")
    if (target.exists) {
      val conf = TomcatConfig(scala.xml.XML.load(new FileInputStream(target)))
      val datasources = new collection.mutable.HashMap[String, DataSource]
      for (context <- conf.webapp.contexts) {
        conf.farms.find(f => f.name == context.runAt).foreach { farm =>
          for (ds <- context.dataSources) datasources += (ds.name -> ds)
        }
      }
      if (datasources.isEmpty) {
        logger.info("Cannot find datasource")
        return
      }

      if (datasources.size == 1) dataSource = datasources.values.head
      println("Sql executor:help ls exec exit(quit/q)")
      shell({
        val prefix =
          if (null != dataSource) dataSource.name
          else "sql"
        prefix + " >"
      }, Set("exit", "quit", "q"), command => command match {
        case "ls" => info(conf)
        case "help" => printHelp()
        case t => {
          if (t.startsWith("use")) use(conf, trim(substringAfter(t, "use")))
          else if (t.startsWith("exec")) exec(conf, trim(substringAfter(t, "exec")))
          else if (isNotEmpty(t)) println(t + ": command not found...")
        }
      })
    } else {
      logger.info("Cannot find config.xml")
    }
  }

  def sqlFiles: Array[String] = {
    val file = new File(sqlDir)
    if (file.exists) {
      val files = for (f <- file.list() if f.endsWith(".sql")) yield f
      files.sorted
    } else Array.empty
  }

  def exec(conf: TomcatConfig, file: String = null) {
    if (isBlank(file)) {
      println("Usage exec all or exec file1 file2")
    } else {
      var fileName = file
      if (file == "all") fileName = sqlFiles.mkString(" ")
      val urls = new collection.mutable.ListBuffer[URL]
      for (name <- split(fileName, " ")) {
        val f = new File(sqlDir + (if (name.endsWith(".sql")) name else name + ".sql"))
        if (f.exists) {
          urls += f.toURL
        } else {
          println("file " + f.getAbsolutePath() + " doesn't exists")
        }
      }

      val runner = new Runner(OracleParser, urls: _*)
      if (null == dataSource) use(conf, null)
      if (null == dataSource || urls.isEmpty) {
        println("Execute sql aborted.")
      } else {
        if (null == dataSource.driverClassName) {
          dataSource.driverClassName = Vendors.drivers.get(dataSource.driver) match {
            case Some(di) => di.className
            case None => println("cannot find driver " + dataSource.driver + "className"); "unknown"
          }
        }
        val format = new UrlFormat(dataSource.url)
        if (!format.params.isEmpty) {
          val params = format.params
          val values = new collection.mutable.HashMap[String, String]
          params.foreach { param => values.put(param, prompt("enter " + param + ":")) }
          dataSource.url = format.fill(values.toMap)
        }

        if (null == dataSource.password)
          dataSource.password = readPassword("enter datasource [%1$s] %2$s password:", dataSource.name, dataSource.username)

        val ds = new PoolingDataSourceFactory(dataSource.driverClassName,
          dataSource.url, dataSource.username, dataSource.password, dataSource.properties).getObject

        runner.execute(ds, true)
      }
    }
  }

  def printHelp() {
    println("""Avaliable command:
  ls                        print datasource and sql file"
  exec [sqlfile1,sqlfile2]  execute simple file 
  exec all                  execute all sql file
  help              print this help conent""")
  }

  def use(conf: TomcatConfig, datasourceName: String = null) {
    val datasources = new collection.mutable.HashMap[String, DataSource]
    for (context <- conf.webapp.contexts) {
      conf.farms.find(f => f.name == context.runAt).foreach { farm =>
        for (ds <- context.dataSources) datasources += (ds.name -> ds)
      }
    }
    if (datasources.isEmpty) {
      println("datasource is empty")
    } else {
      if (!isBlank(datasourceName) && datasources.get(datasourceName).isDefined) {
        dataSource = datasources(datasourceName)
      } else {
        val selectName = prompt("choose datasource name?", null, name => datasources.contains(name))
        dataSource = datasources(selectName)
      }
    }
  }

  def info(conf: TomcatConfig) {
    val infos = new collection.mutable.ListBuffer[String]
    var index = 0
    for (context <- conf.webapp.contexts) {
      conf.farms.find(f => f.name == context.runAt).foreach { farm =>
        for (ds <- context.dataSources) {
          var prefix = if (ds == dataSource) "[*] " else "[" + index + "] "
          infos += prefix + ds.toString
        }
      }
    }
    println("Data sources:\n" + ("-" * 50))
    println(infos.mkString("\n"))
    println()
    println("Sql files:\n" + ("-" * 50))
    println(sqlFiles.mkString(" "))
  }
}