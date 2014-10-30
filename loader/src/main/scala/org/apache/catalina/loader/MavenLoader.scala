package org.apache.catalina.loader

import java.io.LineNumberReader
import java.io.FileReader
import org.apache.catalina.loader.WebappLoader
import org.apache.catalina.loader.WebappClassLoader
import java.io.File
import javax.servlet.ServletContext
import org.apache.catalina.Context
import java.net.URL

class MavenLoader(parent:ClassLoader )   extends WebappLoader(parent){

       var webClassPathFile = ".#webclasspath";
       var tomcatPluginFile = ".tomcatplugin";

    def this()    {
        this(null)
    }

    def  startInternal(){
        log("Starting DevLoader");
        super.startInternal();
        val cl = super.getClassLoader();
        if(!(cl.isInstanceOf[WebappClassLoader]))        {
            logError("Unable to install WebappClassLoader !");
            return;
        }
        val devCl = cl.asInstanceOf[WebappClassLoader]
        readWebClassPathEntries() foreach {url => 
         devCl.addURL(url)
        }
    }

    protected def log(msg:String )
    {
        println((new StringBuilder("[DevLoader] ")).append(msg).toString());
    }

    protected def logError(msg:String )
    {
        System.err.println((new StringBuilder("[DevLoader] Error: ")).append(msg).toString());
    }

    protected def readWebClassPathEntries():List[URL]=  {
        val prjDir =   new File(servletContext.getRealPath("/"))
        if(prjDir == null)
            return List.empty
          loadWebClassPathFile(prjDir)
    }

    protected def loadWebClassPathFile(prjDir:File ):List[String]=     {
        File cpFile;
        FileReader reader;
        cpFile = new File(prjDir, webClassPathFile);
        if(!cpFile.exists())
            break MISSING_BLOCK_LABEL_99;
        reader = null;
        List rc;
        rc = new ArrayList();
        reader = new FileReader(cpFile);
        LineNumberReader lr = new LineNumberReader(reader);
        for(String line = null; (line = lr.readLine()) != null;)
        {
            line = line.replace('\\', '/');
            rc.add(line);
        }

        return rc;
        IOException ioEx;
        ioEx;
        if(reader == null);
        return null;
        return null;
    }

    protected def servletContext:ServletContext = 
    {
      this.getContext.getServletContext
    }
}